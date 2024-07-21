class_name  PlaceableObject extends Sprite2D

signal object_selected(id)

var parent: Node2D
var mode: Global.Mode = Global.Mode.eposition
var visual: Visual
var details: Details
var interactable: Interaction
var input: InputHandler

func _ready():
	interactable = Interaction.new(Rect2(get_real_pos() - Vector2(self.get_extents().x /2, self.get_extents().y/2), get_extents()))
	visual = Visual.new()
	details = Details.new()
	input = InputHandler.new()
	if not get_parent() is Window:
		parent = get_parent()
		parent.mode_change.connect(_mode_change)
	self.interactable.mouse_entered_rect.connect(_mouse_hovered)
	self.interactable.log_event.connect(log_to_console)

func _process(delta):
	input.get_input(self)
	interactable.update(input.local_mouse_position, get_real_pos())
	_manipulate()

func _physics_process(delta):
	pass

func _manipulate():
	if mode == Global.Mode.eposition:
		handle_position()

func handle_position():
	if (interactable.mouse_hover and input.pressed_left_click) or interactable.is_dragged:
		interactable.is_dragged = true
		position = input.global_mouse_position

func _unhandled_input(event: InputEvent):
	interactable.check_input(event)

func _mouse_hovered():
	pass

func set_region(rect: Rect2):
	region_enabled = true
	region_rect = rect

func _draw():
	draw_rect(interactable.rect, Color(0, 0, 0.5, 0.5), true)

func get_real_pos():
	return Vector2(self.global_position.x - position.x, self.global_position.y - position.y)

func get_extents():
	return Vector2(self.texture.get_width(), self.texture.get_height())

func _mode_change(_mode: Global.Mode):
	self.mode = _mode

func log_to_console(msg: String, signal_val = ""):
	print(self.name, " ", signal_val, msg)

func _save():
	var data = {
		"object_type": "item",
		"filename": get_scene_file_path(),
		"nodepath": get_path(),
		"name": self.name,
		"pos_x": position.x,
		"pos_y": position.y,
		"atlas": visual.save(),
		"region": region_enabled,
		"reg_x": region_rect.position.x,
		"reg_y": region_rect.position.y,
		"user_defined": details.save()
	}
	return data

func load(data):
	name = data["name"]
	position = Vector2(data["pos_x"], data["pos_y"])
	visual.load(data["atlas"])
	var x = data["reg_x"]
	var y = data["reg_y"]
	set_region(Rect2(x, y, 32, 32))
	details.load(data["user_defined"])
