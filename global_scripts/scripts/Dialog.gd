extends Control

signal DialogComplete
signal NextDialog

var dialog_speed : float
var left_img_string : String
var right_img_string : String
var left_img
var right_img
var text_to_show : String

var show_dialog := false
var displaying_text = false

@onready var dialog_text = $dialog_container/text_container/dialog_text

func _ready():
	dialog_speed = 0.01
	StartText("this is the first line on the dialog text sample")
	
func _process(delta):
	if Input.is_action_just_pressed("recenter") and visible:
		displaying_text = false
		dialog_text.text = text_to_show

func SetUpCharacters():
	if left_img_string and right_img_string:
		left_img = load(left_img_string)
		right_img = load(right_img_string)
		$dialog_container/character_focus/left_/character.texture = left_img
		$dialog_container/character_focus/right_/character.texture = right_img

func CharacterFocus(focus: String):
	var opposite = 'left_' if focus == 'right_' else 'right_'
	get_node("dialog_container/character_focus/" + focus + '/character').modulate = '#808080'
	get_node("dialog_container/character_focus/" + opposite + '/character').modulate = '#808080'

func StartText(text: String):
	text_to_show = text
	dialog_text.text = ""
	displaying_text = true
	var t = 0
	while displaying_text:
		dialog_text.text += text_to_show[t]
		t += 1
		displaying_text = dialog_text.text != text_to_show
		await get_tree().create_timer(dialog_speed).timeout

func StartDialog(text: String, left: String, right: String, focus: String):
	left_img_string = left
	right_img_string = right
	SetUpCharacters()
	CharacterFocus(focus)
	visible = true
	await get_tree().create_timer(0.5).timeout
	StartText(text)

func ExitDialog():
	visible = false
	text_to_show = ""
	dialog_text.text = text_to_show
	displaying_text = false
