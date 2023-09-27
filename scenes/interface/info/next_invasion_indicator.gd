extends VBoxContainer

var indicators = []
var Hbox = []
var tileMap
var indicator_texture = load("res://assets/GUI/indicator.png")
var count = 30
var deleting = true


func _ready():
	print('next invasion loaded')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !tileMap:
		var tile_map = get_tree().get_root().get_node('Overworld_tilemap')
		if tile_map:
			tileMap = tile_map
			tileMap.connect("CharacterMovedOverview", Callable(self, "CountDown"))
			tileMap.connect("ResetCountdown", Callable(self, "SetUpIndicators"))
			SetUpIndicators()
			set_process(false)

func SetUpIndicators():
	if tileMap.to_next_invasion <= 0:
		return
	print('indicator setup')
	var next_invasion_count = tileMap.to_next_invasion
	var HB = HBoxContainer.new()
	HB.add_theme_constant_override('separation', 1)
	HB.size_flags_horizontal = 8
	Hbox.append(HB)
	for x in range(next_invasion_count):
		if x % 11 == 0 and x != 0:
			print('new row')
			var ref_rect = ReferenceRect.new()
			ref_rect.custom_minimum_size.x = 5.0
			HB.add_child(ref_rect)
			add_child(HB)
			move_child(HB, -2)
			$bg.scale.y += 1.75
			HB = HBoxContainer.new()
			HB.add_theme_constant_override('separation', 1)
			HB.size_flags_horizontal = 8
			Hbox.append(HB)
		var rect = TextureRect.new()
		rect.size_flags_horizontal = 0
		rect.texture = indicator_texture
		indicators.append(rect)
		HB.add_child(rect)
		if x == next_invasion_count - 1:
			var ref_rect = ReferenceRect.new()
			ref_rect.custom_minimum_size.x = 5.0
			HB.add_child(ref_rect)
			add_child(HB)
			move_child(HB, -2)
			$bg.scale.y += 1.75

func CountDown():
	print('Character moved in invasion indicator')
	if len(indicators) > 0:
		var to_del = indicators[-1]
		indicators.erase(to_del)
		to_del.queue_free()
	if len(indicators) % 11 == 0 and len(Hbox) > 0:
		var to_del = Hbox[-1]
		Hbox.erase(to_del)
		to_del.queue_free()
		$bg.scale.y -= 1.75
