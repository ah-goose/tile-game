extends Node

@onready var astar_grid = AStarGrid2D.new()
var rand = RandomNumberGenerator.new()
var number_of_gems = 0
var grid_size_x = 30
var grid_size_y = 20
var grid_cell_size = 16
var update_resource = true
var is_invasion_phase = false
var is_prep_phase = true
var is_inside_base = false

var resources = {
	'rock': 0,
	'wood': 0,
#	'water': 0,
	'food': 0,
	'workers': 1,
	'gems': 0
}
var resources_max = {
	'rock': 0,
	'wood': 0,
#	'water': 0,
	'food': 0,
	'workers': 1000,
	'gems': 0
}
var resources_aquire_rate = {
	'rock': 1,
	'wood': 1,
	'water': 1,
	'food': 1,
	'gems': 1,
	'workers': 1
}

var resource_cost = {
	'rock': {'gems': 30},
	'trees': {'gems': 25},
	'house': {'gems': 25, 'food': 50},
	'farm': {'gems': 25},
	'tower': {'wood': 50, 'rock': 50, 'food': 30},
	'wall': {'wood': 10, 'rock': 10},
	'door': {'wood': 15, 'rock': 15}
}

# Tower powers
var tower_dmg = 1
var tower_radius = 64
var tower_max_amo = 5
var tower_amo = 5

var key_resource_focus = null
var game_over = false
func _ready():
	RandomizeTilemapSize()
	astar_grid.size = Vector2i((grid_cell_size * grid_size_x), (grid_cell_size * grid_size_y))
	astar_grid.cell_size = Vector2i(grid_cell_size, grid_cell_size)
	astar_grid.jumping_enabled = false
	astar_grid.default_compute_heuristic = 1
	astar_grid.default_estimate_heuristic = 3
	astar_grid.diagonal_mode = 1
	astar_grid.update()

func UpdateTileGrid(grid_id, is_active):
	var from_grid = Vector2i(grid_id.x - grid_cell_size/2, grid_id.y - grid_cell_size/2)
	var to_grid = Vector2i(grid_id.x + grid_cell_size/2, grid_id.y + grid_cell_size/2)
	for g in astar_grid.get_id_path(from_grid, to_grid):
		astar_grid.set_point_solid(g, is_active)
#	astar_grid.set_point_solid(grid_id, true)

func AddResource(res : String):
	if res in ['rock', 'wood', 'food']:
		resources[res] += (resources_aquire_rate[res] * resources['workers'])
	else:
		resources[res] += resources_aquire_rate[res]
	update_resource = true

func UpdateEconomy(obj):
	for r in resource_cost[obj]:
		resources[r] -= resource_cost[obj][r]
	update_resource = true

func UpdateResourceMax(resource, max):
	resources_max[resource] = max
	update_resource = true

func RandomizeTilemapSize():
	rand.randomize()
	grid_size_x = rand.randi_range(30, 60)
	grid_size_y = rand.randi_range(30, 60)

func ChangeScene(scene):
	var remove_scene = get_tree().get_root().get_child(0)
	get_tree().change_scene_to_file(scene)
