extends 'res://scenes/levels/level_base.gd'

@onready var gui = $GUI

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func StartEndGame():
	Global.is_final_invasion = true
	to_next_invasion = 0
	gui.is_preping = true
	SetUpFinalInvasion()
	
func CompleteLevel():
	print('completed game')
	level_completed = true
	Global.mission_complete = true
	LevelFinished()

