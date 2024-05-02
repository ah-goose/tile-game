extends CanvasLayer

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
var dialog_text_array : Array
var text_index = 0

@onready var dialog_text = $Dialog/dialog_container/text_container/dialog_text

func _ready():
	dialog_speed = 0.01
	
func _process(delta):
	if Input.is_action_just_pressed("recenter") and visible:
		if !displaying_text:
			text_index += 1
			if text_index >= dialog_text_array.size():
				ExitDialog()
			else:
				StartText()
		else:
			displaying_text = false
			dialog_text.text = text_to_show

func SetUpCharacters():
	if left_img_string and right_img_string:
		left_img = load(left_img_string)
		right_img = load(right_img_string)
		$Dialog/dialog_container/character_focus/left_/character.texture = left_img
		$Dialog/dialog_container/character_focus/right_/character.texture = right_img

func CharacterFocus(focus: String):
	var opposite = 'left_' if focus == 'right_' else 'right_'
	get_node("Dialog/dialog_container/character_focus/" + focus + '/character').modulate = '#ffffff'
	get_node("Dialog/dialog_container/character_focus/" + opposite + '/character').modulate = '#808080'

func StartText():
	print('started text')
	text_to_show = dialog_text_array[text_index].text
	dialog_text.text = ""
	displaying_text = true
	CharacterFocus(dialog_text_array[text_index].focus)
	var t = 0
	while displaying_text:
		dialog_text.text += text_to_show[t]
		t += 1
		displaying_text = dialog_text.text != text_to_show
		await get_tree().create_timer(dialog_speed).timeout

func StartDialog(text: Array, left: String, right: String, focus: String):
	print('dialog started')
	left_img_string = left
	right_img_string = right
	dialog_text_array = text
	text_index = 0
	SetUpCharacters()
	CharacterFocus(focus)
	$Dialog.visible = true
	await get_tree().create_timer(0.5).timeout
	StartText()

func ExitDialog():
	$Dialog.visible = false
	text_to_show = ""
	dialog_text.text = text_to_show
	displaying_text = false
	emit_signal("DialogComplete")
