extends Node2D

signal palette_index_changed(id: int)
signal mode_changed(mode: Global.Mode)

var mode: Global.Mode
var terrain_idx: int

@export var toolbar_scale: int = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	$toolbar_terrain.btn_clicked.connect(btn_mode_changed)
	$toolbar_tools.btn_clicked.connect(btn_mode_changed)
	$toolbar_objects.btn_clicked.connect(btn_mode_changed)
	$toolbar_characters.btn_clicked.connect(btn_mode_changed)
	$toolbar_terrain.scale *= toolbar_scale
	$toolbar_tools.scale *= toolbar_scale
	$toolbar_objects.scale *= toolbar_scale
	$toolbar_characters.scale *= toolbar_scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("mode_position"):
		mode = Global.Mode.eposition
		print("mode set to position")
	if event.is_action_pressed("mode_rotation"):
		mode = Global.Mode.erotation
		print("Mode set to rotation")
	if event.is_action_pressed("mode_scale"):
		mode = Global.Mode.escale
		print("Mode set to scale")

func btn_mode_changed(id: String, coord: Vector2):
	print(id)
	var split = id.split("_")
	if split[1] == "tool":
		match(id):
			"btn_tool_rotate": mode = Global.Mode.erotation
			"btn_tool_move": mode = Global.Mode.eposition
			"btn_tool_select": mode = Global.Mode.eselect
			"btn_tool_multiselect": mode = Global.Mode.emulti
			"btn_tool_resize": mode = Global.Mode.escale
			"btn_tool_cancel": mode = Global.Mode.ecancel
			"btn_tool_paint": mode = Global.Mode.epaint
			"btn_tool_erase": mode = Global.Mode.eerase
			"btn_tool_bucket": mode = Global.Mode.ebucket
			"btn_tool_picker": mode = Global.Mode.epicker	
		mode_changed.emit(mode)
	if split[1] == "terrain":
		terrain_idx = 0
		palette_index_changed.emit(terrain_idx, coord)
	if split[1] == "object":
		terrain_idx = 1
		palette_index_changed.emit(terrain_idx, coord)
		pass
	if split[1] == "character":
		terrain_idx = 2
		palette_index_changed.emit(terrain_idx, coord)
		pass
	pass
