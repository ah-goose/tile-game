extends Node2D

var bullet_count : int
var can_shoot := true
var origin : Vector2
@export var damage : float
@export var range : int
@export var reload_speed : int
@export var bullet_capacity : int
@export var bullet_speed : float

var bullet = preload("res://scenes/character/bullet.tscn")

func _ready():
	bullet_count = bullet_capacity
	$reload_timer.wait_time = reload_speed

func Shoot(target: Vector2):
	if !can_shoot: 
		return
	var bull =  bullet.instantiate()
	bull.target = target
	bull.damage = damage
	bull.bullet_speed = bullet_speed
	add_child(bull)
	
	bullet_count -= 1
	if bullet_count <= 0:
		can_shoot = false
		$reload_timer.start()

func _on_reload_timer_timeout():
	bullet_count = bullet_capacity
	can_shoot = true
