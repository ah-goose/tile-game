extends CharacterBody2D

var damage = 5.0
var bullet_speed = 100.0
var target
var angle_dir = false
var distance := 100
var bull_origin : Vector2

func _ready():
	bull_origin = global_position
	
func _process(delta):
	move(delta)

func DisapearBullet():
	self.visible = false
	$KillTimer.stop()
	$CollisionShape2D.disabled = true
	set_process(false)
	queue_free()
	
func move(delta):
	print(abs(global_position.distance_to(bull_origin)) >= distance)
	if abs(global_position.distance_to(bull_origin)) >= distance:
		DisapearBullet()
		return
	if !angle_dir:
		look_at(target)
		angle_dir = true
	var vel = transform.x * bullet_speed * delta
	var collision = move_and_collide(vel)
	if collision:
		var col = collision.get_collider()
		print(col.get_groups())
		if 'invader' in col.name or "invader" in collision.get_collider().get_groups():
			col.TakeDamage(damage)
			DisapearBullet()
#		if "zombie" in collision.get_collider().get_groups():
#			pass
			

func HitTarget(tar):
	tar.TakeDamage(damage)
	print('target hit', tar)
	DisapearBullet()


func _on_kill_timer_timeout():
	DisapearBullet()
