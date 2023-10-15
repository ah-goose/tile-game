extends Area2D

signal UpdateTile(tile_coords, map_coords)
signal RemoveTile(tile_coords)
signal AddBuilding(building)
signal RemoveBuilding(building)

var top
var bottom
var left
var right

var is_highlighted = false
var is_active = false
var is_mouseover = false
var to_select_tile = false
var walkable = false
var highlight_color = Color.BEIGE
var active_color = Color.DARK_RED
var in_use = false
var tile_coordinates : Vector2i
var has_gem = true
var is_home_base = false

var tile_focus = 'default'
var prev_tile_focus = 'default'
var hp = 0

var is_wall = false

var tower = preload("res://scenes/env/towers/tower.tscn")
var tower_dmg = 1
var tower_radius = 64
var tower_max_amo = 5
var tower_amo = 5


var rnd = RandomNumberGenerator.new()

@onready var tower_attack_line = Line2D.new()

var path_tile_id : Vector2i

var current_water_hits = 0
var current_wall_hits = 0
var current_door_hits = 0

var is_river = false
var river_coords = {
	0 : Vector2i(1, 13),
	'n': Vector2i(0, 14),
	'ne': Vector2i(0, 15),
	'nes': Vector2i(4, 14),
	'new': Vector2i(4, 13),
	'nesw': Vector2i(1, 14),
	'ns': Vector2i(0, 14),
	'nsw': Vector2i(3, 14),
	'nw': Vector2i(2, 15),
	'e': Vector2i(1, 13),
	'es': Vector2i(0, 13),
	'esw': Vector2i(3, 13),
	'ew': Vector2i(1, 13),
	's': Vector2i(0, 14),
	'sw': Vector2i(2, 13),
	'w': Vector2i(1, 13)
}
var bridge_coords = {
	0: Vector2i(1, 4),
	'w': Vector2i(3, 34),
	'e': Vector2i(3, 34),
	'n': Vector2i(2, 34),
	's': Vector2i(2, 34),
}
var wall_coords = {
	0 : Vector2i(1, 0),
	'n': Vector2i(2, 1),
	'ne': Vector2i(0, 2),
	'nes': Vector2i(3, 1),
	'new': Vector2i(4, 1),
	'nesw': Vector2i(1, 3),
	'ns': Vector2i(2, 1),
	'nsw': Vector2i(4, 0),
	'nw': Vector2i(2, 2),
	'e': Vector2i(1, 0),
	'es': Vector2i(0, 0),
	'esw': Vector2i(3, 0),
	'ew': Vector2i(1, 0),
	's': Vector2i(2, 1),
	'sw': Vector2i(2, 0),
	'w': Vector2i(1, 0)
}
var door_coords = {
	0: Vector2i(3, 2),
	'w': Vector2i(3, 2),
	'e': Vector2i(3, 2),
	'n': Vector2i(4, 2),
	's': Vector2i(4, 2),
}
var tile_images = {
	'default': load("res://assets/tile.png"),
	'rock': load("res://assets/rock-1.png"),
	'tower': load("res://assets/tower.png")
}

var tile_functionality = {
	'default': {
		'hp': 0, 
		'action': null, 
		'setup': 'ResetTile', 
		'params': null, 
		'group': null,
		'coords': false,
		'collider': false
	},
	'rock': { 
		'hp': 1, 
		'action': 'AddResource',
		'params': 'rock',
		'setup': null,
		'coords': Vector2i(3, 1),
		'group': 'building',
		'max_increase': 200,
		'collider': true
	},
	'trees': { 
		'hp': 1, 
		'action': 'AddResource',
		'params': 'wood', 
		'setup': null, 
		'coords': Vector2i(2, 3),
		'group': 'building',
		'max_increase': 200,
		'collider': true
	},
	'farm': { 
		'hp': 1, 
		'action': 'AddResource',
		'params': 'food', 
		'setup': null, 
		'coords': Vector2i(6, 6),
		'group': 'building',
		'max_increase': 200,
		'collider': true
	},
	'house': { 
		'hp': 1, 
		'action': null,
		'params': 'workers', 
		'setup': 'AddResource', 
		'coords': Vector2i(2, 1),
		'group': 'building',
		'collider': true
	},
	'tower': {
		'hp': 2, 
		'action': null,
		'params': null,
		'setup': 'TowerSetup', 
		'coords': Vector2i(0, 3),
		'group': 'building',
		'collider': true
	},
	'wall': {
		'hp': 5, 
		'action': null,
		'params': null,
		'setup': 'WallSetup', 
		'coords': Vector2i(1, 3),
		'group': 'building',
		'collider': true
	},
	'door': {
		'hp': 5,
		'action': null,
		'params': null,
		'setup': 'DoorSetup',
		'coords': Vector2i(1, 4),
		'group': 'building',
		'collider': true
	},	# create function to handle this
	'road': {'img': Vector2i(0, 0), 'hp': 1, 'action': null},
	'river': {
		'hp': 0,
		'action': null,
		'params': null,
		'setup': 'RiverSetup',
		'coords': Vector2i(0, 0),
		'group': 'env',
		'collider': true
	},
	'bridge': {
		'hp': 0,
		'action': null,
		'params': null,
		'setup': 'BridgeSetup',
		'coords': Vector2i(0, 0),
		'group': 'env',
		'collider': true
	}
}
func _ready():
	tower_attack_line.default_color = Color.DARK_GREEN
	tower_attack_line.width = 4
	add_child(tower_attack_line)
	tower_dmg = Settings.tower_dmg
	tower_radius = Settings.tower_radius
	tower_max_amo = Settings.tower_max_amo
	tower_amo = Settings.tower_amo

func _process(delta):
	if Global.is_inside_base:
		return
	if is_highlighted:
		$Sprite2D.visible = true
		modulate = active_color if is_active else highlight_color
		modulate.a = 0.5
	else:
		$Sprite2D.visible = false
		modulate = Color.WHITE
		modulate.a = 1
		
#	if to_select_tile:
#		if Input.is_action_just_pressed('left_mouse_click'):
#			var character = get_tree().root.get_node('character')
#			var tile_use = character.action_tile_use == 'add'
#			var resource_to_use = character.tile_resource
#			UseTile(resource_to_use, tile_use)
	if is_wall:
		CheckWallView()
	if is_river:
		CheckRiverView()

func TileCheck():
	pass

func HighlightSurrounding():
	if top:
		top.is_highlighted = is_highlighted and is_mouseover
	if bottom:
		bottom.is_highlighted = is_highlighted and is_mouseover
	if left:
		left.is_highlighted = is_highlighted and is_mouseover
	if right:
		right.is_highlighted = is_highlighted and is_mouseover

func SetHighlighted():
	is_highlighted = true
	is_mouseover = true
	HighlightSurrounding()

func RemoveHighlighted():
	is_highlighted = false
	is_mouseover = false
	HighlightSurrounding()
	
func ResetTile(params = false):
	if 'max_increase' in tile_functionality[prev_tile_focus]:
		print('decreasing max of ', tile_functionality[prev_tile_focus].params)
		var decrease_to = Global.resources_max[tile_functionality[prev_tile_focus].params] - tile_functionality[prev_tile_focus].max_increase
		Global.UpdateResourceMax(tile_functionality[prev_tile_focus].params, decrease_to)
		prev_tile_focus = 'default'
	if tile_focus == 'tower':
		for c in get_children():
			if 'tower' in c.get_groups():
				c.queue_free()
				break
	is_active = false
	is_wall = false
	walkable = false
	rnd.randomize()
	$tile_collision/CollisionShape2D.disabled = true
	emit_signal("RemoveTile", tile_coordinates)
	emit_signal("RemoveBuilding", self)
	
	tile_focus = 'default'
	hp = 0
	for g in get_groups():
		if g not in ['tile', '_process']:
			remove_from_group(g)
	$Sprite2D.position.y = 0
	
func UseTile(obj, active):
	is_active = active
	prev_tile_focus = obj if tile_focus == 'default' else prev_tile_focus
	tile_focus = obj
	
	has_gem = false
	$Gem.disable_mode = true
	$Gem.visible = has_gem
	$tile_collision/CollisionShape2D.disabled = !tile_functionality[obj].collider
	if tile_functionality[obj].group:
		add_to_group(tile_functionality[obj].group)
		if tile_functionality[obj].group == 'building':
			emit_signal("AddBuilding", self)
	if tile_functionality[obj].hp:
		hp = tile_functionality[obj].hp
	if tile_functionality[obj].coords:
		emit_signal('UpdateTile', tile_coordinates, tile_functionality[obj].coords)
	if 'max_increase' in tile_functionality[obj]:
		var increase_to = tile_functionality[obj].max_increase + Global.resources_max[tile_functionality[obj].params]
		Global.UpdateResourceMax(tile_functionality[obj].params, increase_to)
	if tile_functionality[obj].setup:
		call(tile_functionality[obj].setup, tile_functionality[obj].params)
	if obj not in ['default', 'river', 'bridge']:
		Global.UpdateEconomy(obj)
#	$'/root/Global'.UpdateTileGrid(global_position, is_active)

func RockSetup():
	hp = 1
	emit_signal('UpdateTile', tile_coordinates, tile_functionality['rock'].coords)
#	$Sprite2D.position.y = 0

func TowerSetup(params = null):
	var new_tower = tower.instantiate()
	new_tower.radius = Game.tower_stats['tower_radius']
	new_tower.bullet_damage = Game.tower_stats['tower_dmg']
	new_tower.fire_rate_timer = Game.tower_stats['tower_fire_rate']
	hp = Game.tower_stats['tower_hp']
	add_child(new_tower)
	add_to_group('building')
	hp = tile_functionality['tower'].hp
	emit_signal('UpdateTile', tile_coordinates, tile_functionality['tower'].coords)

func AddResource(resource = null):
	if Global.resources[resource] < Global.resources_max[resource]:
		Global.AddResource(resource)

func RockBlock():
	pass

func WallSetup(params = false):
	is_wall = true
	hp = Game.wall_stats['hp']

func DoorSetup(params = false):
	walkable = true
	is_wall = true

func RiverSetup(params = false):
	is_river = true

func BridgeSetup(params = false):
	is_river = true
	walkable = true
	
func TowerAttack(param):
	if tower_amo <= 0:
		tower_amo = tower_max_amo
		return
	else:
		var zombies = get_tree().get_nodes_in_group('zombie')
		var closest_zombie
		var distance_to_closest_zombie
		for z in zombies:
			var distance_from = global_position.distance_to(z.global_position)
			if distance_from <= tower_radius:
				if closest_zombie:
					closest_zombie = z if distance_from < distance_to_closest_zombie else closest_zombie
				else:
					closest_zombie = z
					distance_to_closest_zombie = distance_from
		if closest_zombie:
			tower_attack_line.add_point(Vector2i.ZERO)
			tower_attack_line.add_point(Vector2i(closest_zombie.global_position - position))
			closest_zombie.TakeDamage(tower_dmg)
			await get_tree().create_timer(1).timeout
			tower_amo -= 1
			tower_attack_line.clear_points()
		elif tower_amo < tower_max_amo:
			tower_amo = tower_max_amo

func TakeDamage(dmg):
	hp -= dmg
	if hp <= 0:
		ResetTile()
		
func CheckRiverView():
	var wall_hits = ''
	var walkable_hits = ''
	if top.is_river:
		wall_hits += 'n'
		if walkable:
			walkable_hits = 'n'
	if right.is_river:
		wall_hits += 'e'
		if walkable:
			walkable_hits = 'e'
	if bottom.is_river:
		wall_hits += 's'
		if walkable:
			walkable_hits = 's'
	if left.is_river:
		wall_hits += 'w'
		if walkable:
			walkable_hits = 'w'
	if wall_hits == '':
		wall_hits = 0
	if walkable_hits == '':
		walkable_hits = 0
	current_water_hits = wall_hits
	current_water_hits = walkable_hits
	if current_water_hits in ['ns', 'nes', 'new', 'esw', 'ew', 'nesw']:
		walkable = false
		tile_focus = 'river'
	if walkable:
		emit_signal('UpdateTile', tile_coordinates, bridge_coords[walkable_hits])
	else:
		emit_signal('UpdateTile', tile_coordinates, river_coords[wall_hits])

func CheckWallView():
	var wall_hits = ''
	var walkable_hits = ''
	if top.is_wall:
		wall_hits += 'n'
		if walkable:
			walkable_hits = 'n'
	if right.is_wall:
		wall_hits += 'e'
		if walkable:
			walkable_hits = 'e'
	if bottom.is_wall:
		wall_hits += 's'
		if walkable:
			walkable_hits = 's'
	if left.is_wall:
		wall_hits += 'w'
		if walkable:
			walkable_hits = 'w'
	if wall_hits == '':
		wall_hits = 0
	if walkable_hits == '':
		walkable_hits = 0
	current_wall_hits = wall_hits
	current_door_hits = walkable_hits
	if walkable:
		emit_signal('UpdateTile', tile_coordinates, door_coords[walkable_hits])
	else:
		emit_signal('UpdateTile', tile_coordinates, wall_coords[wall_hits])

func _on_Character_move():
	if tile_functionality[tile_focus].action:
		call(tile_functionality[tile_focus].action, tile_functionality[tile_focus].params)

func _on_tile_mouse_entered():
	if !to_select_tile:
		to_select_tile = true


func _on_tile_mouse_exited():
	if to_select_tile:
		to_select_tile = false


func _on_Area2D_area_entered(area):
	if 'zombie' in area.get_groups() and tile_focus != 'default':
		print('area zombie entered')
		


func _on_gem_area_entered(area):
	if 'building' in area.get_groups():
		has_gem = false
		$Gem.disable_mode = true
		$Gem.visible = has_gem
		is_active = true
	
	if 'main_base' in area.get_groups():
		is_home_base = true
		
	if 'character' in area.get_groups():
		if has_gem:
			Global.AddResource('gems')
			has_gem = false
			$Gem.disable_mode = true
			$Gem.visible = has_gem
