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
	}
}
func _physics_process(delta):
	if (Global.CheckResources("rock") or Global.CheckResources("trees") or Global.CheckResources("farm")) and !dialog_triggers['resources'].complete:
		TriggerTutorial('resources')
		
		
	if (Global.CheckResources("house") and !dialog_triggers['workers'].complete):
		TriggerTutorial('workers')
		

func TriggerTutorial(trigg: String):
	dialog_focus = dialog_triggers[trigg].dialog_index
	var dialog_dict = dialog[dialog_focus].dialog
	dialog_triggers[trigg].complete = true
	StartDialog(dialog_dict.dialog, dialog_dict.left_, dialog_dict.right_, dialog_dict.dialog[0].focus)

func _on_first_invasion_start_timeout():
	if !dialog_triggers['shooting'].complete:
		TriggerTutorial('shooting')
