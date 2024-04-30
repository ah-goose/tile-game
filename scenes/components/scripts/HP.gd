extends Node2D

class_name HPComponent
signal LostAllHP
var hp : int
@export var max_health : int

@onready var progress_bar = $ProgressBar

func _ready():
	hp = max_health
	progress_bar.max_value = max_health
	progress_bar.value = hp

func TakeDamage(damage: int):
	var new_hp = hp - damage
	if new_hp <= 0:
		hp = 0
		emit_signal("LostAllHP")
	else:
		hp = new_hp
	progress_bar.value = hp

func Recover(health: int):
	var new_hp = hp + health
	if new_hp > max_health:
		hp = max_health
	else:
		hp = new_hp
	progress_bar.value = hp
