extends Area2D

var hp = 500
var max_hp = 500
var is_active = true

var fire_rate = 0.75
var bullet = preload("res://scenes/character/bullet.tscn")
var can_fire = true

var defending = true

func _process(delta):
	if Input.is_action_just_pressed("left_mouse_click") and Global.is_inside_base:
		Shoot()

func GetHit(dmg):
	hp -= dmg
	print('base hp ', hp)
	if hp <= 0:
		print('GAME OVER!!!!')
		Global.game_over = true
#		queue_free()
		# Game over

func Shoot():
	var target_focus = get_global_mouse_position()
	var bull = bullet.instantiate()
	bull.target = target_focus
	add_child(bull)
	
func _on_fortify_body_entered(body):
	pass # Replace with function body.
