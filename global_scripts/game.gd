extends Node


var file_name_options = [
	'user://save_slot_1.bat',
	'user://save_slot_2.bat',
	'user://save_slot_3.bat',
]
var focus_file = 0

var tutorial = true
var knowledge_points = 0

var unlocked_lore = []

var tower_stats = {'tower_dmg': 1, 'tower_radius': 4, 'tower_max_amo': 5}
var tower_max_stats = {'tower_dmg': 10, 'tower_radius': 8, 'tower_max_amo': 50}

var resource_cost = {
	'rock': {'gems': 30},
	'trees': {'gems': 25},
	'house': {'gems': 25, 'food': 50},
	'farm': {'gems': 25},
#	'tower': {'wood': 50, 'rock': 50, 'food': 30},
	'tower': {'gems': 1},
	'wall': {'wood': 10, 'rock': 10},
	'door': {'wood': 15, 'rock': 15}
}

var resource_cost_max = {
	'rock': {'gems': 5},
	'trees': {'gems': 5},
	'house': {'gems': 10, 'food': 20},
	'farm': {'gems': 5},
#	'tower': {'wood': 10, 'rock': 10, 'food': 10},
	'tower': {'gems': 1},
	'wall': {'wood': 2, 'rock': 2},
	'door': {'wood': 2, 'rock': 2}
}

func UpgradeTower(upgrade):
	var point = 1
	if upgrade == 'tower_max_amo':
		point = 5
	
	if (tower_stats[upgrade] + point) <= tower_max_stats[upgrade]:
		tower_stats[upgrade] += point

func UpgradeResource(upgrade):
	var resource = resource_cost[upgrade]
	var points = 1 if upgrade in ['wall', 'door'] else 5
	for r in resource:
		if (resource_cost[upgrade][r] - points) >= resource_cost_max[upgrade][r]:
			resource_cost[upgrade][r] -= points
	print('resources ', upgrade, ' ', resource_cost[upgrade])
