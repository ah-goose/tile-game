extends TextureButton

signal show_description
signal hide_description

@export var image_src : String
@export var type_btn := 'resource'
@export var value : String
@export var short_description : String
@export var resource_name : String
var resource_available : bool
var resource_needs = {}

var character
@onready var sprite_2d = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if image_src:
		sprite_2d.texture = load(image_src)
	if value and value != 'unequip':
		resource_needs = Global.resource_cost[value]
	print('just checking %s' % ['somthing'])
	print(resource_needs.keys())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if value != 'unequip':
		CheckAvailability()
	if not character:
		GetCharacter()
		

func CheckAvailability():
	resource_available = Global.CheckResources(value)
	if resource_available:
		modulate.a = 1
	else:
		modulate.a = 0.5

func GetCharacter():
	character = get_tree().get_first_node_in_group('character')
	
func EquipItem():
	var equip = value != 'unequip'
	character.EquipResource(value, equip)

func _on_mouse_entered():
	if value == 'unequip':
		emit_signal('show_description', short_description, [])
		return
	sprite_2d.position.y -= 10
	var out = []
	for i in resource_needs.keys():
		print(Global.resources[i])
		print(resource_needs[i])
		var details = {
			'text': '%s: %s/%s' % [i, str(Global.resources[i]), str(resource_needs[i])],
			'color': '#ffffff' if Global.resources[i] >= resource_needs[i] else '#ff0000'
		}
		out.push_back(details)
	emit_signal("show_description", short_description, out)


func _on_mouse_exited():
	if value == 'unequip':
		emit_signal('hide_description')
	else:
		sprite_2d.position.y += 10
		emit_signal("hide_description")


func _on_pressed():
	if resource_available or value == 'unequip':
		EquipItem()
