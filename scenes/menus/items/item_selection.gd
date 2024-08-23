extends Control
signal construct_selection

@export var player : Area2D

var options_disabled := true
var is_showing = false

@onready var build_desc = $CenterContainer/VBoxContainer/build_description
var btn_list = []

var sample_text = 'This is a description\nthis is second line\nanother line'
func _ready():
	if player:
		player.connect("view_options", Callable(self, "ShowOptions"))
		player.connect("hide_options", Callable(self, "HideOptions"))
		UpdateDescription(sample_text)
	for btn in $btn_list.get_children():
		btn.connect("show_description", Callable(self, '_on_show_description'))
		btn.connect('hide_description', Callable(self, '_on_hide_description'))
	btn_list = get_node("btn_list").get_children()
	HideOptions()

func _process(delta):
	if get_tree().is_paused():
		HideOptions()
	if is_showing and Input.is_action_just_pressed('use_action'):
		HideOptions()

func UpdateDescription(description: String):
	build_desc.text = description

func AddLabel(text, color):
	var deet_label = Label.new()
	deet_label.text = text
	deet_label.modulate = color
	deet_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	deet_label.add_theme_color_override('font_outline_color', '#000000')
	deet_label.add_theme_constant_override('outline_size', 5)
	deet_label.add_to_group('available_resources')
	$CenterContainer/VBoxContainer.add_child(deet_label)

func RemoveLabel():
	get_tree().call_group('available_resources', 'queue_free')
	
func ShowOptions():
	player.set_process(false)
	self.modulate.a = 1
	options_disabled = false
	EnableBtn()
	await get_tree().create_timer(1)
	is_showing = true
	set_process(true)
	

func HideOptions():
	self.modulate.a = 0
	options_disabled = true
	DisableBtn()
	player.set_process(true)
	is_showing = false
	set_process(false)

func DisableBtn():
	for b in btn_list:
		b.disabled = true

func EnableBtn():
	for b in btn_list:
		b.disabled = false


func _on_show_description(short_description, res_out):
	print(res_out)
	UpdateDescription(short_description if short_description else '')
	for i in res_out:
		AddLabel(i.text, i.color)

func _on_hide_description():
	UpdateDescription('')
	RemoveLabel()
