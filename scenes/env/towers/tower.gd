extends StaticBody2D

var hp := 10
var max_hp := 10
var fire_frequency : float
var target = null
var target_options = []
var bullet = preload("res://scenes/character/bullet.tscn")
var bullet_capacity = 5.0
var bullets_left = 5.0
var can_fire = true
var radius := 10.0

@onready var reload_speed_timer = $reload_speed_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.is_invasion_phase:
		CheckTarget()
		
func TakeDamage(dmg):
	hp -= dmg
	if hp <= 0:
		queue_free()
		
func CheckTarget():
	target_options = get_tree().get_nodes_in_group('invader')
	print('all invaders', target_options)
	for t in target_options:
		if abs(position.distance_to(t.position)) / 2 <= radius:
			target = t
			break
	if target != null:
		Shoot(target.global_position)
		target = null

func Shoot(tar):
	if bullets_left == 0:
		return
#	bullets_left -= 1
	var bull = bullet.instantiate()
	bull.target = tar
	add_child(bull)
	if bullets_left == 0 and reload_speed_timer.is_stopped():
		can_fire = false
		reload_speed_timer.start()
