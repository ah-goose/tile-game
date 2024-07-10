extends Control
signal construct_selection

@export var player : Area2D

var options_disabled := true

@onready var build_desc = $CenterContainer/build_description

var sample_text = 'This is a description\nthis is second line\nanother line'
func _ready():
	if player:
		player.connect("view_options", Callable(self, "ShowOptions"))
		player.connect("hide_options", Callable(self, "HideOptions"))
		UpdateDescription(sample_text)

func _process(delta):
	pass

func UpdateDescription(description: String):
	build_desc.text = description

func ShowOptions():
	self.modulate.a = 1
	options_disabled = false

func HideOptions():
	self.modulate.a = 0
	options_disabled = true
