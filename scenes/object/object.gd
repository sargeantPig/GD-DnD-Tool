extends Node2D

# Object script to control the rotation and placement of objects. This should be generic and applied to each placeable object


var parent: Node2D
var sprite: Texture2D 
var mouseHover: bool = false
var selected: bool = false
var mode: Global.Mode


func _ready():
	#$box/sprite.texture = sprite
	var p = get_parent()
	if p.name == "root":
		parent = p
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent != null:
		mode = parent.mode
	if selected:
		modulate = Color("blue", 0.25)
	else: modulate = Color("white")
	if parent != null:
		mode = parent.mode
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

func _input(event):
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
	pass # Replace with function body.
