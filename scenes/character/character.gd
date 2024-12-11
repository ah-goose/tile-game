extends Area2D
class_name Character
signal CharacterMoved
signal view_options
signal hide_options
signal CharacterDestroyed
var is_active = true
var active_tile

var is_going_to_use_tile = false
var is_moving = false
var action_tile_use = 'add'
var tile_resource = null
var last_tile_resource_selected = null
var res_options = false

var last_location : Vector2i
var can_enter_base = false
var is_dead = false
var gems = 0

@export var hp : HPComponent
@onready var animation_player = $AnimationPlayer
@onready var auto_walk = $AutoWalk

func _ready():
#	active_tile.SetHighlighted()
	animation_player.play('idle')
	if len(get_tree().get_nodes_in_group('camera')) > 0:
		get_tree().get_nodes_in_group('camera')[0].player = self

func _process(delta):
	if is_dead:
		return
	if Global.is_final_invasion and auto_walk.is_stopped():
		auto_walk.start()
		
	if Input.is_action_just_pressed("left_mouse_click") && $Shooter.can_shoot && Global.CheckResources('bullet'):
		var targ = get_global_mouse_position()
		$Shooter.Shoot(targ)
		Global.UpdateEconomy('bullet')
		if !Global.is_final_invasion:
			emit_signal("CharacterMoved")
		
	if Global.is_inside_base and $Sprite2D.visible:
		$Sprite2D.visible = false
	elif !Global.is_inside_base and !$Sprite2D.visible:
		$Sprite2D.visible = true
	
	if can_enter_base and Global.is_invasion_phase:
		$to_enter.visible = true
		#if Input.is_action_just_pressed("use_action"):
		#	Global.is_inside_base = true
		#	$to_enter.visible = false
	else:
		$to_enter.visible = false
	
	if Global.is_inside_base and Global.is_invasion_phase:
		return
	
	if Global.game_over:
		set_process(false)
		return
	if tile_resource != null:
		is_going_to_use_tile = true
		action_tile_use = 'add'
	elif tile_resource == null and is_going_to_use_tile and action_tile_use == 'add':
		is_going_to_use_tile = false

	if !is_going_to_use_tile:
		Movement()
		
	if is_going_to_use_tile:
		HighlightTiles('set')
		if action_tile_use == 'add':
			UseTile()
		if action_tile_use == 'remove':
			RemoveTile()
	else:
		HighlightTiles('remove')
	if Input.is_action_just_pressed("use_action"):
		emit_signal('view_options')
		action_tile_use = 'add'
	if Input.is_action_just_pressed('other_action'):
		is_going_to_use_tile = !is_going_to_use_tile
		action_tile_use = 'remove'
	if Input.is_action_just_pressed("get_last_resource"):
		if tile_resource == null:
			EquipStoredResource()
		else:
			tile_resource = null
	
func Movement():
	if is_moving:
		return
	if Input.is_action_pressed("move_down"):
		MoveToTile("bottom")
	elif Input.is_action_pressed("move_up"):
		MoveToTile("top")
	elif Input.is_action_pressed("move_left"):
		$Sprite2D.scale.x = -1
		MoveToTile("left")
	elif Input.is_action_pressed("move_right"):
		$Sprite2D.scale.x = 1
		MoveToTile("right")

func MoveToTile(tile):
	if Global.is_inside_base:
		Global.is_inside_base = false
	var allowed_to_walk = active_tile[tile] and (!active_tile[tile].is_active or active_tile[tile].walkable)
	if allowed_to_walk:
		is_moving = true
#		tween.interpolate_value(global_position, active_tile[tile].global_position, 0.25, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		var new_tween = create_tween()
		new_tween.tween_property(self, 'global_position', active_tile[tile].global_position, 0.25)
		new_tween.tween_callback(self.FinishedMoving)
#		(self, global_position, 100, 200, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		global_position = active_tile[tile].global_position
		active_tile = active_tile[tile]
		
		if !Global.is_final_invasion:
			emit_signal("CharacterMoved")
	else:
		return

func FinishedMoving():
	is_moving = false
	
func UseTile():
	if Input.is_action_just_pressed("move_down"):
		ActivateUseTile("bottom")
	if Input.is_action_just_pressed("move_up"):
		ActivateUseTile("top")
	if Input.is_action_just_pressed("move_left"):
		ActivateUseTile("left")
	if Input.is_action_just_pressed("move_right"):
		ActivateUseTile("right")

func HighlightTiles(action):
	if action == 'set':
		active_tile.SetHighlighted()
	else:
		active_tile.RemoveHighlighted()

func ActivateUseTile(tile):
	is_going_to_use_tile = false
	if active_tile[tile] and !active_tile[tile].is_active and tile_resource:
		active_tile[tile].UseTile(tile_resource, true)
		
		if !Global.is_final_invasion:
			emit_signal("CharacterMoved")
		tile_resource = null
	else:
		return

func RemoveTile():
	if Input.is_action_just_pressed("move_down"):
		ActivateRemoveTile("bottom")
	if Input.is_action_just_pressed("move_up"):
		ActivateRemoveTile("top")
	if Input.is_action_just_pressed("move_left"):
		ActivateRemoveTile("left")
	if Input.is_action_just_pressed("move_right"):
		ActivateRemoveTile("right")
		
func ActivateRemoveTile(tile):
	is_going_to_use_tile = false
	if active_tile[tile] and active_tile[tile].is_active:
		active_tile[tile].UseTile('default', false)
		
		if !Global.is_final_invasion:
			emit_signal("CharacterMoved")
	else:
		return

func EquipResource(res, equip):
	if equip:
		tile_resource = res
		last_tile_resource_selected = res
	else:
		tile_resource = null
	res_options = false
	emit_signal('hide_options')

func EquipStoredResource():
	if last_tile_resource_selected == null:
		return
	else:
		var available_resource = Global.CheckResources(last_tile_resource_selected)
		if available_resource:
			tile_resource = last_tile_resource_selected

func TakeDamage(damage: int):
	hp.TakeDamage(damage)
	
func _LostAllHP():
#	auto_walk.start()
	get_node("CollisionShape2D").disabled = true
	get_node("Sprite2D").visible = false
	get_node("HP").visible = false
	is_dead = true
	emit_signal("CharacterDestroyed")

func _on_auto_walk_timeout():
	emit_signal("CharacterMoved")
