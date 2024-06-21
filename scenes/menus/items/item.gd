extends PanelContainer

var item_name : String
var item_description : String
var item_cost : int
var function_name : String
var function_params

@onready var section_label = $Sections/Label
@onready var cost = $"Sections/Cost Panel/VBoxContainer/Cost"
@onready var description = $Sections/Control/Description


# Called when the node enters the scene tree for the first time.
func _ready():
	UpdateText(item_name, item_cost, item_description)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateText(n: String, c: int, d: String):
	section_label.text = n
	cost.text = '$' + str(c)
	description.text = d


func _on_buy_item():
	print('buying item')
	if item_cost <= Global.total_earnings:
		Global.total_earnings -= item_cost
		Global.call(function_name, function_params)
		for i in Global.store_items:
			if i.item_name == item_name:
				i.owned = true
				break;
		queue_free()
