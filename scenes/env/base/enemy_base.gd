extends Area2D

@export var hp : HPComponent

func TakeDamage(dmg: int):
	hp.TakeDamage(dmg)
	
func _LostAllHP():
	print('won the level')
	queue_free()



func _on_body_entered(body):
	if 'bullet' in body.get_groups():
		TakeDamage(body.damage)
		body.DisapearBullet()
