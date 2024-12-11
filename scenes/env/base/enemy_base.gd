extends Area2D

signal BaseDestroyed

@export var hp : HPComponent
@export var subbases : Array[EnemySubbase]
var has_shield := true
@onready var cave_shield = $CaveShield

func _ready():
	if subbases.size() > 0:
		for b in subbases:
			b.connect("BaseDestroyed", Callable(self, 'SubbaseDestroyed'))
	else:
		HideShield()

func TakeDamage(dmg: int):
	if has_shield:
		return
	hp.TakeDamage(dmg)
	
func _LostAllHP():
	print('won the level')
	emit_signal("BaseDestroyed")
	queue_free()

func HideShield():
	has_shield = false
	cave_shield.visible = false

func SubbaseDestroyed(sub: EnemySubbase):
	subbases.erase(sub)
	if subbases.size() <= 0:
		HideShield()
	print(subbases)

func _on_body_entered(body):
	if 'bullet' in body.get_groups():
		TakeDamage(body.damage)
		body.DisapearBullet()
