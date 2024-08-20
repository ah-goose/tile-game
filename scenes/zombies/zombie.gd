extends Area2D

var active_tile
var target
var hp := 3
var base
var buildings := []
var path : Array
var steps_to_destination = 0

@export var hp_bar : HPComponent
@onready var line_path = Line2D.new()
@onready var nav_agent := $NavigationAgent2D

func _ready():
	self.connect('area_entered', Callable(self, '_on_zombie_body_entered'))
	$AnimationPlayer.play("walking")
	GetTarget()

func _process(delta):
	if path.is_empty():
		GetTarget()
	if Global.game_over:
		set_process(false)
		return
	if not target:
		GetTarget()
		

func _LostAllHP():
	line_path.clear_points()
	remove_from_group('zombie')
#		await get_tree().create_timer(1).timeout
	queue_free()
func Move():
	if !target:
		GetTarget()
		return
	nav_agent.target_position = target.global_position
	var next_point = to_local(nav_agent.get_next_path_position()).normalized()
	var x_move = abs(next_point[0]) > abs(next_point[1])
	if x_move:
		if next_point[0] > 0.0:
			MoveToTile('right')
			$Sprite2D.scale.x = 1
		else:
			$Sprite2D.scale.x = -1
			MoveToTile('left')
	else:
		if next_point[1] < 0:
			MoveToTile('top')
		else:
			MoveToTile('bottom')
	print(to_local(nav_agent.get_next_path_position()).normalized())
	pass

func Moveold():
	if path.is_empty():
		return
	line_path.clear_points()
	nav_agent.target_position = target.global_position
	var x = path[(steps_to_destination * $'/root/Global'.grid_cell_size)].x - path[(steps_to_destination * $'/root/Global'.grid_cell_size) + 1].x
	var y = path[(steps_to_destination * $'/root/Global'.grid_cell_size)].y - path[(steps_to_destination * $'/root/Global'.grid_cell_size) + 1].y
	if x > 0:
		$Sprite2D.scale.x = -1
		MoveToTile('left')
	if x < 0:
		MoveToTile('right')
		$Sprite2D.scale.x = 1
	if y > 0:
		MoveToTile('top')
	if y < 0:
		MoveToTile('bottom')
	await get_tree().create_timer(0.5).timeout
	steps_to_destination += 1
	if len(path) <= (steps_to_destination * $'/root/Global'.grid_cell_size) + $'/root/Global'.grid_cell_size:
		target = null
		GetTarget()
	if (target == null):
		GetTarget()
	var path2 = $'/root/Global'.astar_grid.get_id_path(global_position, target.global_position)
	
	for p in path2:
		line_path.add_point(Vector2i(p.x - position.x, p.y - position.y))

func MoveToTile(tile):
	if active_tile[tile]:
		var tween = create_tween()
		tween.tween_property(self, 'global_position', active_tile[tile].global_position, 0.25)
		global_position = active_tile[tile].global_position
		active_tile = active_tile[tile]
	else:
		return

func GetBuildings():
	buildings = get_tree().get_nodes_in_group('building')
	if buildings.size() > 0:
		GetTarget()
	
func GetTarget():
	if hp <= 0:
		return
	var closest_building
	if target and target.hp <= 0:
		buildings.erase(target)
		target = null
	if !target and buildings.size() > 0:
		for build in buildings:
			if target:
				var a = $'/root/Global'.astar_grid.get_id_path(global_position, target.global_position).size()
				var b = $'/root/Global'.astar_grid.get_id_path(global_position, build.global_position).size()
				if a > b:
					target = build
			else:
				target = build
	path = Global.astar_grid.get_id_path(global_position, target.global_position)
	
	
	steps_to_destination = 0

func TakeDamage(dmg: int):
	if hp_bar:
		hp_bar.TakeDamage(dmg)

func _on_Character_move():
	if Global.game_over:
		return
	if hp > 0:
		GetBuildings()
		Move()

func _on_zombie_body_entered(body):
	
	if 'main_base' in body.get_groups():
		base.GetHit(hp)
		queue_free()
	elif 'bullet' in body.get_groups():
		TakeDamage(body.damage)
		body.DisapearBullet()
	else:
		var groups = body.get_groups()
		if 'building' in groups:
			var dmg = body.hp
			body.TakeDamage(hp)
			hp -= dmg
			if hp > 0 and body.hp <= 0:
				buildings.erase(target)
				target = null
				GetTarget()


func _on_area_entered(area):
	print('zombie body enter ', area.get_groups() )
	if 'character' in area.get_groups():
		print('character hit')
		if area.has_method('TakeDamage'):
			print('character take damage')
			var dmg = area.hp.hp
			area.TakeDamage(hp)
			TakeDamage(dmg)
