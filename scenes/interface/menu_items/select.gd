extends Control

var resource_available = false
var resource_needs = {}
@export var resource = 'rock'

var equipped = false
var equip_available = false

var character

func _ready():
	resource_needs = Global.resource_cost[resource]
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
	
	if Input.is_action_just_pressed('left_mouse_click') and equip_available and resource_available:
		EquipItem()

func GetCharacter():
	character = get_tree().get_first_node_in_group('character')

func EquipItem():
	equipped = not equipped
	if equipped:
		character.tile_resource = resource
	else:
		character.tile_resource = null
	$equiped.visible = equipped

func EquipStatus():
	$equiped.visible = equipped

func CheckAvailability():
	var is_available = true
	for n in resource_needs:
		if not is_available:
			continue
		else:
			is_available = Global.resources[n] >= resource_needs[n]
	resource_available = is_available
	if resource_available:
		modulate.a = 1
	else:
		modulate.a = 0.5

func _on_item_mouse_entered():
	equip_available = true

func _on_item_mouse_exited():
	equip_available = false
