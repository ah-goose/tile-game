extends Node2D

var tile = preload("res://scenes/tile.tscn")
var tiles = {}
var all_tiles = []
var prev_tile
var character = preload("res://scenes/character/character.tscn")
var zombie = preload("res://scenes/zombies/zombie.tscn")
var main_base = preload("res://scenes/env/base/home_base.tscn")
var enemy_base = preload("res://scenes/env/base/enemy_base.tscn")
var all_buildings = []
#var GUI_Preset = preload("res://scenes/GUI.gd").instanciate()
var active_zombie
var base
var base_tile_x
var base_tile_y

var eb
var eb_tile_x
var eb_tile_y

var total_invasions = 5
var to_next_invasion = 0
var to_next_invasion_count = -1

var invader_spawn_rate = 0.75
var target_invasion
var invasion_wave = 1
var number_of_invaders = 5
var is_invading = false
var invading_count_down = false
var invader = preload("res://scenes/zombies/invader.tscn")
var add_invader_frequency = 1.5

@onready var tile_map = $TileMap
@onready var camera = $camera
@onready var invasion_duration = $InvasionDuration
@onready var spawn_invader = $SpawnInvader
@onready var prep_phase = $PrepPhase

var rnd = RandomNumberGenerator.new()
signal CharacterMovedOverview
signal ResetCountdown




func _ready():
	SetUpCamera()
	SetUpTile()
	SetUpCharacter()
	SetUpBase()
	$FirstInvasionStart.start()
	rnd.randomize()
	Global.is_invasion_phase = false
#	prep_phase.start()


func SetUpCamera():
	camera.enabled = true
	camera.limit_top = -100
	camera.limit_left = -100
	camera.limit_right = get_viewport_rect().size.x if get_viewport_rect().size.x > ($'/root/Global'.grid_size_x * $'/root/Global'.grid_cell_size) else ($'/root/Global'.grid_size_x * $'/root/Global'.grid_cell_size) + 50
	camera.limit_bottom = get_viewport_rect().size.y if get_viewport_rect().size.y > ($'/root/Global'.grid_size_y * $'/root/Global'.grid_cell_size) else ($'/root/Global'.grid_size_y * $'/root/Global'.grid_cell_size) + 50
#	camera.zoom = Vector2(2, 2)
	camera.make_current()
	
func SetUpTile():
	tile_map.add_layer(1) # Road
	tile_map.add_layer(2) # other
	var ts = Global.grid_cell_size
	for x in range(Global.grid_size_x):
		for y in range(Global.grid_size_y):
			var new_tile = tile.instantiate()
			new_tile.position.x = (x * ts) + (ts/2)
			new_tile.position.y = (y * ts) + (ts/2)
			prev_tile = new_tile
			if y != 0:
				new_tile.top = tiles[x][y-1]
				tiles[x][y-1].bottom = new_tile
			if x in tiles:
				tiles[x].append(new_tile)
			else:
				tiles[x] = [new_tile]
			all_tiles.append(new_tile)
			new_tile.modulate.a = 0.2
			new_tile.tile_coordinates = Vector2i(x, y)
			self.connect("CharacterMovedOverview", Callable(new_tile, '_on_Character_move'))
			new_tile.connect("UpdateTile", Callable(self, '_on_update_tile_map'))
			new_tile.connect("RemoveTile", Callable(self, '_on_remove_tile'))
			new_tile.connect("AddBuilding", Callable(self, 'AddBuildingToList'))
			new_tile.connect("RemoveBuilding", Callable(self, 'RemoveBuildingFromList'))
			GrassTileSetup(Vector2i(x, y))
			add_child(new_tile)
		if x != 0:
			for a in tiles[x].size():
				tiles[x][a].left = tiles[x-1][a]
				tiles[x-1][a].right = tiles[x][a]

func SetUpRiver():
	
	var x_min = base_tile_x if base_tile_x < eb_tile_x else eb_tile_x
	var x_max = base_tile_x if base_tile_x > eb_tile_x else eb_tile_x
	
	var y_min = base_tile_y if base_tile_y < eb_tile_y else eb_tile_y
	var y_max = base_tile_y if base_tile_y > eb_tile_y else eb_tile_y
	var sp_x = rnd.randi_range(x_min, x_max)
	var sp_y = rnd.randi_range(y_min, y_max)
	var river_w = rnd.randi_range(10, Global.grid_size_x / 2)
	var river_h = rnd.randi_range(10, Global.grid_size_y / 2)
	while river_w + sp_x >= Global.grid_size_x:
		river_w = rnd.randi_range(10, Global.grid_size_x / 2)
	while river_h + sp_y >= Global.grid_size_y:
		river_h = rnd.randi_range(10, Global.grid_size_x / 2)
	for x in river_w:
		if x == 0:
			for y in river_h:
				if tiles[sp_x][sp_y + y].tile_focus == 'river':
					continue
				if (y > river_h/2 or (y < river_h/2)):
					tiles[sp_x][sp_y + y].UseTile('river', true)
				else:
					tiles[sp_x][sp_y + y].UseTile('bridge', true)
		elif x == river_w - 1:
			for y in river_h:
				if tiles[sp_x + x][sp_y + y].tile_focus == 'river':
					continue
				if y > river_h/2 or (y < (river_h/2) ):
					tiles[sp_x + x][sp_y + y].UseTile('river', true)
				else:
					tiles[sp_x + x][sp_y + y].UseTile('bridge', true)
		else:
			
			if (x > river_w/2  or (x < (river_w/2) )):
				if tiles[sp_x + x][sp_y].tile_focus != 'river':
					tiles[sp_x + x][sp_y].UseTile('river', true)
				if tiles[sp_x + x][sp_y + river_h - 1].tile_focus != 'river':
					tiles[sp_x + x][sp_y + river_h - 1].UseTile('river', true)
			else:
				if tiles[sp_x + x][sp_y].tile_focus == 'default':
					tiles[sp_x + x][sp_y].UseTile('bridge', true)
				if tiles[sp_x + x][sp_y + river_h - 1].tile_focus == 'default':
					tiles[sp_x + x][sp_y + river_h - 1].UseTile('bridge', true)
	
func GrassTileSetup(coords : Vector2i):
	var tile_x = rnd.randi_range(0, 4)
	tile_map.set_cell(0, coords, 0, Vector2i(tile_x, 4))
	
func SetUpCharacter():
	var mid_point_x = ($'/root/Global'.grid_size_x / 2) - 2
	var mid_point_y = ($'/root/Global'.grid_size_y / 2) - 2
	var new_char = character.instantiate()
	var selected_tile = tiles[mid_point_x][mid_point_y]
	new_char.active_tile = selected_tile
	new_char.position = selected_tile.position
	new_char.connect("CharacterMoved", Callable(self, '_character_moved'))
	camera.player = new_char
	add_child(new_char)
	

func SetUpBase():
	var mid_point_x = floor((Global.grid_size_x - 1) / 2)
	var mid_point_y = floor((Global.grid_size_y - 1) / 2)
	var new_base = main_base.instantiate()
	var selected_tile = tiles[mid_point_x][mid_point_y]
	new_base.position = selected_tile.position
	camera.mid_point = selected_tile.position
	add_child(new_base)  
	base = new_base

func AddInvader():
	var available_tiles = []
	for t in all_tiles:
		if !t.is_active:
			available_tiles.append(t)
	rnd.randomize()
	var tile_choosen_coords = rnd.randi_range(0, (len(available_tiles) - 1))
	var tile_choosen = available_tiles[tile_choosen_coords]
	while base.position.distance_to(tile_choosen.position) < 100:
		available_tiles.remove_at(tile_choosen_coords)
		tile_choosen_coords = rnd.randi_range(0, (len(available_tiles) - 1))
		tile_choosen = available_tiles[tile_choosen_coords]
	var inv = invader.instantiate()
	inv.target = base
	inv.global_position = tile_choosen.position
	add_child(inv)

func SetUpNextInvasion():
	if add_invader_frequency > 0.75:
		add_invader_frequency -= 0.01
	to_next_invasion = 2
	to_next_invasion_count = 0
	is_invading = false
	invasion_wave += 1
	emit_signal("ResetCountdown")

func StartInvasion():
	print('invasion started')
	Global.is_invasion_phase = true
	spawn_invader.wait_time = add_invader_frequency
	spawn_invader.start()
#	invasion_duration.start()
	number_of_invaders = 5
	is_invading = true

func AddBuildingToList(building):
	print('added a building')
	all_buildings.append(building)
	print(len(all_buildings))

func RemoveBuildingFromList(building):
	print('removed a building')
	all_buildings.erase(building)
	print(len(all_buildings))
	

func _on_update_tile_map(tile_coords, map_coords):
	tile_map.set_cell(1, tile_coords, 0, map_coords)

func _on_remove_tile(tile_coords):
	tile_map.erase_cell(1, tile_coords)

func _character_moved():
	emit_signal("CharacterMovedOverview")
	if !is_invading and to_next_invasion_count < to_next_invasion and invading_count_down:
		to_next_invasion_count += 1
	if !is_invading and to_next_invasion_count >= to_next_invasion:
		StartInvasion()
		
#	if is_invading and number_of_invaders <= 0:
#		var all_zombies = get_tree().get_nodes_in_group('zombie')
#		if len(all_zombies) == 0:
#			SetUpNextInvasion()


#func _on_first_invasion_start_timeout():
#	invading_count_down = true
#	SetUpNextInvasion()


func _on_invasion_duration_timeout():
	Global.is_invasion_phase = false
	is_invading = false
	to_next_invasion = 1000000
	spawn_invader.stop()

func _on_spawn_invader_timeout():
	if !Global.is_invasion_phase:
		return
	AddInvader()


func _on_prep_phase_timeout():
	invading_count_down = true
	SetUpNextInvasion()
#	prep_phase.stop()
