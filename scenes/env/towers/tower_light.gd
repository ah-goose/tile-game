extends 'res://scenes/env/towers/tower.gd'
var hp_light

# Called when the node enters the scene tree for the first time.
func _ready():
	$LightSource.scale = Game.light_stats['light_radius_scale']


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
