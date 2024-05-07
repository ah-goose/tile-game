extends Area2D

signal BaseDestroyed

@export var hp : HPComponent

func TakeDamage(dmg: int):
	hp.TakeDamage(dmg)
	
func _LostAllHP():
	print('won the level')
	emit_signal("BaseDestroyed")
	queue_free()



func _on_body_entered(body):
	if 'bullet' in body.get_groups():
		TakeDamage(body.damage)
		body.DisapearBullet()
