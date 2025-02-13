extends 'res://scenes/env/towers/tower.gd'

var hp_aid := 10
var target_aid

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func CheckTarget():
	target_options = get_tree().get_nodes_in_group('building')
	for t in target_options:
		if abs(global_position.distance_to(t.global_position)) <= radius and 'hp' in t and 'max_hp' in t:
			if not target_aid:
				target_aid = t
			if (target_aid.hp/target_aid.max_hp) > (t.hp/t.max_hp):
				target_aid = t

func _character_action_taken():
	print('character moved')
	if target_aid != null:
		print('character action taken tower aid ', target_aid)
		target_aid.RecoverAid(hp_aid)
	else:
		print('checking target')
		CheckTarget()
		
