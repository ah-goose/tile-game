extends CanvasLayer
@onready var in_game_pause = $Control/in_game_pause
@onready var base_hp = $Control/HBoxContainer/Container/BaseHP
@onready var prep_invasion = $Control/HBoxContainer/Container/PrepInvasion

var is_preping = true
var is_invading = false
var base

signal PrepDone
signal InvasionDone

func _ready():
	var overworld = get_tree().get_root().get_node('Overworld_tilemap')
	connect("PrepDone", Callable(overworld, '_on_prep_phase_timeout'))
	connect("InvasionDone", Callable(overworld, '_on_invasion_duration_timeout'))

func _physics_process(delta):
	
	if base == null:
		if 'base' in get_tree().get_root().get_node('Overworld_tilemap'):
			base = get_tree().get_root().get_node('Overworld_tilemap').base
			UpdateBaseHP(true, base.hp)
	else:
		if base != null and base_hp.value != base.hp:
			UpdateBaseHP(false, base.hp)
	if Global.update_resource:
		for r in Global.resources:
			var resource_amount = Global.resources[r]
			UpdateResource(r, resource_amount, Global.resources_max[r])
		Global.update_resource = false
	if is_preping:
		print('is preping gui')
		is_preping = false
		var prep_tween = create_tween()
		prep_tween.tween_property(prep_invasion, 'value', 160, 20)
		prep_tween.tween_callback(self.FinishPreping)
		
	if Global.is_invasion_phase and is_invading:
		print('is invading gui')
		is_invading = false
		var invasion_tween = create_tween()
		invasion_tween.tween_property(prep_invasion, 'value', 0, 20)
		invasion_tween.tween_callback(self.FinishInvasion)
		

func UpdateResource(resource, amount, max):
	if resource in ['gems', 'workers']:
		get_node('Control/HBoxContainer/resources/' + resource + '/amount').text = '%d' % amount
	else:
		get_node('Control/HBoxContainer/resources/' + resource + '/amount').text = '%d/%d' % [amount, max]

func FinishPreping():
	is_invading = true
	emit_signal("PrepDone")

func FinishInvasion():
	is_preping = true
	emit_signal("InvasionDone")

func UpdateBaseHP(start, hp):
	if start:
		base_hp.max_value = hp
		base_hp.value = hp
	else:
		if hp <= 0:
			base_hp.value = hp
		else:
			base_hp.value = hp
