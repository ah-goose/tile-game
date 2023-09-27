extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/FullScreen.set_pressed_no_signal(Settings.fullscreen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	Global.ChangeScene("res://scenes/tilemap.tscn")
	


func _on_full_screen_toggled(button_pressed):
	Settings.SetFullscreen(button_pressed)


func _on_quit_pressed():
	get_tree().quit(0)
