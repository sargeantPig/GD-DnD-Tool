class_name InputHandler

var global_mouse_position: Vector2
var local_mouse_position: Vector2

var pressed_left_click: bool
var pressed_right_click: bool
var pressed_shift: bool

var just_left_click: bool
var just_right_click: bool
var just_shift: bool

func get_input(parent: Node2D):
	global_mouse_position = parent.get_global_mouse_position()
	local_mouse_position = parent.get_local_mouse_position()
	pressed_left_click = Input.is_action_pressed("select")
	pressed_right_click = Input.is_action_pressed("deselect")
	just_left_click = Input.is_action_just_pressed("select")
	just_right_click = Input.is_action_just_pressed("deselect")
