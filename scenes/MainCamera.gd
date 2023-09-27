extends Camera2D
var screen_x
var screen_y
var limit_r
var limit_l
var limit_t
var limit_b
var focus_player = false
var player
var mid_point : Vector2

var zoom_in : int
# Called when the node enters the scene tree for the first time.
func _ready():
	set_movement_limits()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("recenter") and player:
		CenterOnCharacter(delta)
#		global_position = player.global_position
	else:
		MoveCamera(delta)

func set_movement_limits():
	screen_x = get_viewport_rect().size.x
	screen_y = get_viewport_rect().size.y
	limit_r = get_limit(limit_right) - (screen_x / 2)
	limit_l = get_limit(limit_left) + (screen_x / 2)
	limit_t = get_limit(limit_top) + (screen_y / 2)
	limit_b = get_limit(limit_bottom) - (screen_y / 2)
	zoom_in = 1

func MoveCamera(delta):
	var center_point = get_screen_center_position()
	var mouse_pos = get_global_mouse_position() - center_point
	if mouse_pos:
		if mouse_pos.x < -(screen_x/(zoom_in * 2)) and abs(mouse_pos.x) > (screen_x/(zoom_in * 2)) - 8:
			position.x -= ceil(1 * 160 * delta)
		if mouse_pos.x > (screen_x/(zoom_in * 2))  and abs(mouse_pos.x) > (screen_x/(zoom_in * 2)) - 8:
			position.x += ceil(1 * 160 * delta)
		if mouse_pos.y <= -(screen_y/(zoom_in * 2)) and abs(mouse_pos.y) > (screen_y/(zoom_in * 2)) - 8:
			position.y -= ceil(1 * 160 * delta)
		if mouse_pos.y >= (screen_y/(zoom_in * 2)) and abs(mouse_pos.y) > (screen_y/(zoom_in * 2)) - 8:
			position.y += ceil(1 * 160 * delta)

func CenterOnCharacter(delta):
	if Global.is_inside_base:
		global_position = mid_point
	else:
		global_position = player.global_position

