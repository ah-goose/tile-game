extends CanvasModulate

@export var day_night_cycle := false
@export var dark := false 

@onready var day_night_duration = $day_night_duration
@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	print('day and night cycle is ready')
	Global.is_level_dark = dark
	if dark:
		color = '#000000'
	else:
		color = '#ffffff'
	if day_night_cycle:
		day_night_duration.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if color.r >= 0.5 and dark:
		ToggleDark(false)
	if color.r < 0.5 and !dark:
		ToggleDark(true)
		


func ToggleDark(is_dark_now: bool):
	dark = is_dark_now
	Global.is_level_dark = dark

func _on_day_night_duration_timeout():
	print('day night duration timer completed')
	var animation = 'night_to_day' if dark else 'day_to_night'
	anim_player.play(animation)
	
	


func _on_animation_player_animation_finished(anim_name):
	day_night_duration.start()
