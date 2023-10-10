extends Area2D

var hp = 500
var max_hp = 500
var is_active = true

var reload_speed = 3.25
var bullet = preload("res://scenes/character/bullet.tscn")
var bullet_capacity = 5
var bullets_left = 5
var can_fire = true
@onready var reload_speed_timer = $"reloadTimer"

var defending = true

func _start():
	reload_speed_timer.wait_time = reload_speed

func _process(delta):
	if Input.is_action_just_pressed("left_mouse_click") and Global.is_inside_base and can_fire:
		Shoot()

func GetHit(dmg):
	hp -= dmg
	if hp <= 0:
		print('GAME OVER!!!!')
		Global.game_over = true
#		queue_free()
		# Game over

func Shoot():
	if bullets_left == 0:
		return
	bullets_left -= 1
	print('bullets left ', bullets_left)
	var target_focus = get_global_mouse_position()
	var bull = bullet.instantiate()
	bull.target = target_focus
	add_child(bull)
	if bullets_left == 0 and reload_speed_timer.is_stopped():
		can_fire = false
		reload_speed_timer.start()
	
func _on_fortify_body_entered(body):
	pass # Replace with function body.


func _on_reload_timer_timeout():
	print('reload complete')
	can_fire = true
	bullets_left = bullet_capacity
	reload_speed_timer.stop()
