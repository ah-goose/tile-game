extends 'res://scenes/levels/level_base.gd'

var dialog_triggers = {
	'resources': {
		'complete': false,
		'dialog_index': 1
	},
	'workers': {
		'complete': false,
		'dialog_index': 2
	},
	'shooting': {
		'complete': false,
		'dialog_index': 3
	},
	'attack': {
		'complete': false,
		'dialog_index': 4
	},
	'final': {
		'complete': false,
		'dialog_index': 5
	},
	'complete': {
		'complete': false,
		'dialog_index': 6
	}
}

func _physics_process(delta):
	if (Global.CheckResources("rock") or Global.CheckResources("trees") or Global.CheckResources("farm")) and !dialog_triggers['resources'].complete:
		TriggerTutorial('resources')
		
	if (Global.CheckResources("house") and !dialog_triggers['workers'].complete):
		TriggerTutorial('workers')
	
	if !dialog_triggers['attack'].complete:
		CheckProgress()

func TriggerTutorial(trigg: String):
	dialog_focus = dialog_triggers[trigg].dialog_index
	print('dialog focus ', dialog_focus)
	for d in dialog.size():
		print(d)
		
	var dialog_dict = dialog[dialog_focus].dialog
	dialog_triggers[trigg].complete = true
	await get_tree().create_timer(0.5).timeout
	StartDialog(dialog_dict.dialog, dialog_dict.left_, dialog_dict.right_, dialog_dict.dialog[0].focus)

func CheckProgress():
	var has_buildings = get_tree().get_nodes_in_group('building').size() > 6
	if has_buildings:
		TriggerTutorial('attack')

func StartEndGame():
	Global.is_final_invasion = true
	to_next_invasion = 0
	gui.is_preping = true
	SetUpFinalInvasion()
	TriggerTutorial('final')
	
func CompleteLevel():
	print('completed game')
	level_completed = true
	Global.tutorial_complete = true
	TriggerTutorial("complete")

func _on_first_invasion_start_timeout():
	if !dialog_triggers['shooting'].complete:
		TriggerTutorial('shooting')
