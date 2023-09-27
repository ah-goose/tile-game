extends CharacterBody2D

var damage = 5.0
var bullet_speed = 100.0
var target
var angle_dir = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func DisapearBullet():
	self.visible = false
	$KillTimer.stop()
	$CollisionShape2D.disabled = true
	set_process(false)
	queue_free()
	
func move(delta):
	if !angle_dir:
		look_at(target)
		angle_dir = true
	var vel = transform.x * bullet_speed * delta
	var collision = move_and_collide(vel)
	if collision:
		var col = collision.get_collider()
		if 'invader' in col.name:
			col.TakeDamage(damage)
			DisapearBullet()
#		if "zombie" in collision.get_collider().get("groups"):
#			pass
			

func HitTarget(tar):
	tar.TakeDamage(damage)
	print('target hit', tar)
	DisapearBullet()


func _on_kill_timer_timeout():
	DisapearBullet()
