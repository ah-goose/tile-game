extends Button

@export var level_name: String
@export var level: String

@onready var player = $AnimationPlayer
var greyScale = preload('res://scenes/levels/overworld/level_select.gdshader')
var shader_material
var active = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	var texture_size = $Sprite2D.get_rect().size
	custom_minimum_size = texture_size
	active = level_name not in Global.levels_completed
	if not active:
		GreyScale()

func DefaultState():
	player.stop()
	$Sprite2D.frame = 0
	
func ChangeScene():
	Global.ChangeScene(level)

func GreyScale():
	shader_material = ShaderMaterial.new()
	shader_material.shader = greyScale
	$Sprite2D.material = shader_material
	set_process(false)

func _on_mouse_entered():
	player.play("hovering")



func _on_mouse_exited():
	DefaultState()
