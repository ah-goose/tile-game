extends Control

@export var mission_name : String
@export_multiline var mission_description : String
@export var mission_scene : String

func _ready():
	UpdateLabels()

func _on_select_mission():
	Global.ChangeScene(mission_scene)

func UpdateLabels():
	$HBoxContainer/mission_name.text = mission_name
	$HBoxContainer/PanelContainer/mission_description.set_text(mission_description)
