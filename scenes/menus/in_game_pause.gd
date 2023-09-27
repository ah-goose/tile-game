extends Node2D

func _start():
	print('Is full screen', Settings.fullscreen)
	$VBoxContainer/Fullscreen.set_pressed_no_signal(Settings.fullscreen)

func _unhandled_input(event):
	if event.is_action_pressed('pause_game'):
		if get_tree().paused:
			get_tree().paused = false
			HideMenu()
		else:
			get_tree().paused = true
			ShowMenu()

func ShowMenu():
	print('Is full screen', Settings.fullscreen)
	$VBoxContainer/Fullscreen.set_pressed_no_signal(Settings.fullscreen)
	$ColorRect.visible = true
	$VBoxContainer.visible = true

func HideMenu():
	$ColorRect.visible = false
	$VBoxContainer.visible = false

func _on_return_pressed():
	print('return')
	get_tree().paused = false
	HideMenu()
	


func _on_leave_pressed():
	get_tree().quit(0)


func _on_back_pressed():
	# Should go to title screen
	get_tree().paused = false
	Global.ChangeScene('res://scenes/menus/start_menu.tscn')


func _on_check_button_toggled(button_pressed):
	Settings.SetFullscreen(button_pressed)
