extends Control

var resource_available = false
var resource_needs = {}
@export var resource = 'rock'
@export var tooltip := ''
var equipped = false
var equip_available = false

var character

func _ready():
	resource_needs = Global.resource_cost[resource]
	tooltip_text = tooltip
	print(resource_needs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	CheckAvailability()
	if not character:
		GetCharacter()
		
	if character and character.tile_resource == resource:
		equipped = character.tile_resource == resource
		EquipStatus()
	elif equipped:
		equipped = false
		EquipStatus()
	
	if Input.is_action_just_pressed('right_mouse_click') and equip_available and resource_available:
		EquipItem()

func GetCharacter():
	character = get_tree().get_first_node_in_group('character')

func EquipItem():
	equipped = not equipped
	character.EquipResource(resource, equipped)
	$equiped.visible = equipped

func EquipStatus():
	$equiped.visible = equipped

func CheckAvailability():
	resource_available = Global.CheckResources(resource)
	if resource_available:
		modulate.a = 1
	else:
		modulate.a = 0.5

func _on_item_mouse_entered():
	equip_available = true

func _on_item_mouse_exited():
	equip_available = false
