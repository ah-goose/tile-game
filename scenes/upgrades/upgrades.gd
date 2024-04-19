extends Area2D

@export var label : String

@export_enum(
	'building_strength',
	'wall_strength',
	'wall_resource',
	'tower_resource',
	'tower_damage',
	'tower_fire_rate',
	'tower_radius',
	
	) var type : String

@export var change : float

@export_enum(
	'percentage_positive', 
	'percentage_negative', 
	'unit_positive', 
	'unit_negative'
	) var change_type : String
@export var rarity : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
