extends Control

var item_node = preload('res://scenes/menus/items/item.tscn')

@onready var item_list = $"Items/Items Container/Item List"
@onready var amount = $Items/Currency/amount

# Called when the node enters the scene tree for the first time.
func _ready():
	UpdateAmount()
	UpdateItemList()
	Global.connect('EarningChange', Callable(self, 'UpdateAmount'))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateAmount():
	amount.text = '$' + str(Global.total_earnings)

func UpdateItemList():
	for i in Global.store_items:
		if i.owned:
			continue
		var new_item = item_node.instantiate()
		new_item.item_name = i.item_name
		new_item.item_description = i.item_description
		new_item.item_cost = i.cost
		new_item.function_name = i.action
		print(i.params)
		new_item.function_params = i.params
		item_list.add_child(new_item)
