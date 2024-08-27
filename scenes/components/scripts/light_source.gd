extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = Global.is_level_dark


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible != Global.is_level_dark:
		visible = Global.is_level_dark
