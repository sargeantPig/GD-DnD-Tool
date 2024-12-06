extends Node2D

# Object script to control the rotation and placement of objects. This should be generic and applied to each placeable object
signal object_selected(id)

var parent: Node2D
var id: String
var mouseHover: bool = false
var selected: bool = false
var mode: Global.Mode
var atlas: int = 0
var orig_pos: Vector2

func _ready():
	#$Control/lbl_name.text =  "%s" % self.name
	if not get_parent() is Window:
		parent = get_parent()
		object_selected.connect(parent._managed_object_selected)
		parent.mode_change.connect(_mode_change)
	
	pass # Replace with function body.

func set_real_name():
	if parent == null:
		return
	var num = parent.get_count_by_name(id)
	var mod_name = id.split("_")[-1]
	var real_name = mod_name + "_" + str(num + 1)
	$Control/lbl_name.text = real_name
	$name.text = real_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if parent != null:
	#	mode = parent.mode
	$name.text = $Control/lbl_name.text
	if selected && mode != Global.Mode.emulti:
		$box.modulate = Color("white", 0.75)
		$Control.visible = true
	else: 
		$box.modulate = Color("white")
		$Control.visible = false
	
	if mouseHover:
		$name.visible = true
	else: $name.visible = false
	
	pass

func _physics_process(delta):
	if Global.check_mouse_in_rect(get_local_mouse_position(), get_box()):
		mouseHover = true
	elif !Input.is_action_pressed("select"): mouseHover = false 
	
	if selected:
		if Input.is_action_pressed("select"):
			manipulate_object(0)
		if Input.is_action_pressed("decrease"):
			manipulate_object(-0.1)
		if Input.is_action_pressed("increase"):
			manipulate_object(0.1)

func get_box() -> Rect2:
	return $box/CollisionShape2D.shape.get_rect()

func get_loc_rect() -> Rect2:
	return Rect2(position, Vector2.ONE)

func _unhandled_input(event):
	if event.is_action_pressed("select") && !mouseHover && mode != Global.Mode.emulti:
		selected = false
	if parent == null:
		if event.is_action_pressed("mode_position"):
			mode = Global.Mode.eposition
		if event.is_action_pressed("mode_rotation"):
			mode = Global.Mode.erotation
		if event.is_action_pressed("mode_scale"):
			mode = Global.Mode.escale
		

func _input(event):

	pass

func manipulate_object(value: float):
	match(mode):
		Global.Mode.escale: 
			handle_scale(value)
		Global.Mode.erotation: 
			handle_rotation(value)
		Global.Mode.eposition:
			handle_position(get_global_mouse_position())
		Global.Mode.eerase:
			handle_erase()


func handle_rotation(rot: float):
	rotation += rot
	pass

func handle_position(mousePosition: Vector2):
	if mouseHover:
		position = mousePosition
	pass

func handle_scale(scaler: float):
	scale.x += scaler
	scale.y += scaler
	
func handle_erase():
	self.queue_free()

func restore_defaults():
	rotation = 0
	scale = Vector2(1, 1)
	pass

func _on_box_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("select") && mode != Global.Mode.emulti:
		selected = true
		object_selected.emit(name)
	pass # Replace with function body.

func set_texture(sprite: Texture2D):
	$box/sprite.texture = sprite

func set_region(rect: Rect2):
	$box/sprite.region_enabled = true
	$box/sprite.region_rect = rect

func set_parent(node: Node2D):
	parent = node
	
func _mode_change(_mode: Global.Mode):
	self.mode = _mode

func _save():
	var data = {
		"object_type": "item",
		"filename": get_scene_file_path(),
		"nodepath": get_path(),
		"name": self.name,
		"pos_x": position.x,
		"pos_y": position.y,
		"atlas": atlas,
		"region": $box/sprite.region_enabled,
		"reg_x": $box/sprite.region_rect.position.x,
		"reg_y": $box/sprite.region_rect.position.y,
		"user_defined": $Control.save()
	}
	return data

func load(data):
	name = data["name"]
	position = Vector2(data["pos_x"], data["pos_y"])
	var x = data["reg_x"]
	var y = data["reg_y"]
	set_region(Rect2(x, y, 32, 32))
	$Control.load(data["user_defined"])


