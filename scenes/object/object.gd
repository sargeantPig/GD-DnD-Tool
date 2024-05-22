extends Node2D

# Object script to control the rotation and placement of objects. This should be generic and applied to each placeable object
signal object_selected(id)

var parent: Node2D
var mouseHover: bool = false
var selected: bool = false
var mode: Global.Mode

func _ready():
	$Control/lbl_name.text =  "%s" % self.name
	if not get_parent() is Window:
		parent = get_parent()
		object_selected.connect(parent._managed_object_selected)
		parent.mode_change.connect(_mode_change)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if parent != null:
	#	mode = parent.mode
	if selected:
		$box.modulate = Color("white", 0.75)
		$Control.visible = true
	else: 
		$box.modulate = Color("white")
		$Control.visible = false
	pass

func _physics_process(delta):
	var mouseRect: Rect2 = Rect2(get_local_mouse_position(), Vector2.ONE)
	if $box/CollisionShape2D.shape.get_rect().encloses(mouseRect):
		mouseHover = true
	elif !Input.is_action_pressed("select"): mouseHover = false 
	
	if selected:
		if Input.is_action_pressed("select"):
			manipulate_object(0)
		if Input.is_action_pressed("decrease"):
			manipulate_object(-0.1)
		if Input.is_action_pressed("increase"):
			manipulate_object(0.1)

func _unhandled_input(event):
	if event.is_action_pressed("select") && !mouseHover:
		selected = false
		print("deselected")
	if parent == null:
		if event.is_action_pressed("mode_position"):
			mode = Global.Mode.eposition
			print("mode set to position")
		if event.is_action_pressed("mode_rotation"):
			mode = Global.Mode.erotation
			print("Mode set to rotation")
		if event.is_action_pressed("mode_scale"):
			mode = Global.Mode.escale
			print("Mode set to scale")

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
	pass

func restore_defaults():
	rotation = 0
	scale = Vector2(1, 1)
	pass

func _on_box_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("select"):
		print("selected")
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
