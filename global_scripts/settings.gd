extends Node

var file_name = 'user://saved_settings_tile_game.dat'

var fullscreen = false
var initial = true

var focus_slot = 0

var tower_dmg = 1
var tower_radius = 64
var tower_max_amo = 5
var tower_amo = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	LoadData()
	initial = false

func LoadData():
	if FileAccess.file_exists(file_name):
		var file = FileAccess.open(file_name, FileAccess.READ)
		var data = file.get_var()
		if data:
			fullscreen = data.fullscreen
			focus_slot = data.focus_slot
		file.close()
	SetFullscreen(fullscreen)

func SaveData():
	var to_save = {
		'fullscreen': fullscreen,
		'focus_slot': focus_slot
	}
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	print('saving data')
	file.store_var(to_save)
	file.close()

func SetFullscreen(is_full):
	fullscreen = is_full
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if !initial:
		SaveData()
