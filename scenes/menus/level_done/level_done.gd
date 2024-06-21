extends CanvasLayer

@onready var mission_label = $level_done/CenterContainer/VBoxContainer/Earnings/MissionComplete/Label
@onready var mission_amount = $level_done/CenterContainer/VBoxContainer/Earnings/MissionComplete/amount

@onready var total_amount = $level_done/CenterContainer/VBoxContainer/Earnings/TotalContainer/amount
var mission_earnings = 1000
var total_earnings = 0
var conversion = {
	'Terraverite': 0.1,
	'Aetherium': 0.2,
	'Emberstone': 0.3
}
func _ready():
	PushAmount('Terraverite')
	PushAmount('Aetherium')
	PushAmount('Emberstone')
	PushMission()
	PushTotalEarnings()
	
func PushAmount(resource):
	var label_amount = get_node('level_done/CenterContainer/VBoxContainer/Earnings/' + resource + 'Container/amount')
	var amount = floor(Global.resources[Global.resources_translation_rev[resource]] * conversion[resource])
	total_earnings += amount
	var count = 0
	while count != amount:
		count += 1
		label_amount.text = str(count)
		await get_tree().create_timer(0.01).timeout
	
func PushTotalEarnings():
	total_amount.text = str(total_earnings)
	Global.total_earnings += total_earnings

func PushMission():
	if Global.mission_complete:
		mission_label.text = 'Mission Complete'
		mission_amount.text = str(mission_earnings)
		total_earnings += mission_earnings
	else:
		mission_label.text = 'Mission Failed'
		mission_amount.text = str('0')



func _on_go_home_pressed():
	print('button pressed')
	Global.SaveData()
	Global.ResetResources()
	Global.ChangeScene('res://scenes/menus/home.tscn')
	get_tree().paused = false
	queue_free()
