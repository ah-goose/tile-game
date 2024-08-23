extends CanvasModulate

@export var day_night_cycle := false
@export var dark := false
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.is_level_dark = dark
	if dark:
		color = '#000000'
	else:
		color = '#ffffff'
	if day_night_cycle:
		$AnimationPlayer.play('cycle')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
