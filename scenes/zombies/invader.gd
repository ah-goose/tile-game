extends CharacterBody2D

var move_speed = 50.0
var hp = 10
var damage = 10
var target

func _process(delta):
	if target:
		movement(delta)

func movement(delta):
	var direction = Vector2.ZERO
	direction.x += 1 if position.x < target.position.x else -1 if position.x > target.position.x else 0
	direction.y += 1 if position.y < target.position.y else -1 if position.y > target.position.y else 0
	var vel = direction.normalized() * move_speed
	var collision = move_and_collide(vel * delta)
	if collision:
		var base = collision.get_collider()
		if 'main_base' in base.get_groups():
			base.get_parent().GetHit(damage)
			queue_free()
		elif 'tile_building' in base.get_groups():
			print(base.get_groups())
			var tile = base.get_parent()
			var col_hp = tile.hp
			TakeDamage(col_hp)
			tile.TakeDamage(damage)

func TakeDamage(dmg):
	hp -= dmg
	print(hp)
	if hp <= 0:
		queue_free()

