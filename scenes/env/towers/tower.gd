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
@onready var fire_rate_timer = $fire_rate_timer
@onready var animation_player = $AnimationPlayer
@onready var tower_1 = $"Tower-1"

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.wait_time = fire_frequency
	tower_1.scale.y = ceil(radius/8.0)
	tower_1.scale.x = ceil(radius/8.0)
	animation_player.play("radius_spinner")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_fire:
		CheckTarget()
	tower_1.visible = Global.is_invasion_phase
		
func TakeDamage(dmg):
	hp -= dmg
	if hp <= 0:
		queue_free()
		
func CheckTarget():
	target_options = get_tree().get_nodes_in_group('invader')
	for t in target_options:
		print(abs(global_position.distance_to(t.global_position)), ' ', radius)
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
	add_child(bull)
	fire_rate_timer.start()
	if bullets_left == 0 and reload_speed_timer.is_stopped():
		can_fire = false
		reload_speed_timer.start()


func _on_fire_rate_timer_timeout():
	can_fire = true
	fire_rate_timer.stop()
