extends StaticBody2D

signal TowerDestroyed
var hp := 3
var max_hp := 3
var fire_frequency : float
var target = null
var target_options = []
var bullet = preload("res://scenes/character/bullet.tscn")
var bullet_capacity = 0.0
var bullets_left = 5.0
var bullet_damage = 0.0
var can_fire = true
var radius : float = 16.0

@export var hp_c : HPComponent

@onready var reload_speed_timer = $reload_speed_timer
@onready var fire_rate_timer = $fire_rate_timer
@onready var animation_player = $AnimationPlayer
var view_radius : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.wait_time = fire_frequency

func _draw():
	if view_radius:
		draw_circle(Vector2.ZERO, radius, Color(Color.DARK_GREEN, 0.5))
		draw_arc(Vector2.ZERO, radius, 0.0, 360.0, 360, Color.DARK_GREEN, 3)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	if can_fire:
		CheckTarget()
	if hp_c.max_health != max_hp:
		hp_c.hp = hp
		hp_c.max_health = max_hp
#	tower_1.visible = Global.is_invasion_phase
		
func TakeDamage(dmg):
	print('taking damage in tower ', dmg)
	hp_c.TakeDamage(dmg)

func RecoverAid(aid: int):
	hp_c.Recover(aid)

func CheckTarget():
	target_options = get_tree().get_nodes_in_group('invader')
	for t in target_options:
		if abs(global_position.distance_to(t.global_position)) <= radius:
			target = t
			break
	if target != null:
		Shoot(target.global_position)
		target = null

func Shoot(tar):
	if bullets_left == 0:
		return
#	bullets_left -= 1
	can_fire = false
	
	var bull = bullet.instantiate()
	bull.target = tar
	bull.damage = bullet_damage
	add_child(bull)
	fire_rate_timer.start()
	if bullets_left == 0 and reload_speed_timer.is_stopped():
		can_fire = false
		reload_speed_timer.start()


func _on_fire_rate_timer_timeout():
	can_fire = true
	fire_rate_timer.stop()


func _on_mouse_entered():
	print('mouse entered')
	view_radius = true


func _on_mouse_exited():
	print('mouse entered')
	view_radius = false


func _on_hp_lost_all_hp():
	emit_signal('TowerDestroyed')
#	queue_free()
