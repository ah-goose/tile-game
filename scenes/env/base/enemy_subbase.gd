extends Area2D
class_name EnemySubbase
signal BaseDestroyed

@export var hp : HPComponent


func TakeDamage(dmg: int):
	hp.TakeDamage(dmg)

func _LostAllHP():
	print('subbase destroyed')
	emit_signal("BaseDestroyed", self)
	queue_free()

func _on_body_entered(body):
	if 'bullet' in body.get_groups():
		TakeDamage(body.damage)
		body.DisapearBullet()
