extends Node2D

signal palette_index_changed(id: int)
signal mode_changed(mode: Global.Mode)

var mode: Global.Mode
var terrain_idx: int
# Called when the node enters the scene tree for the first time.
func _ready():
	$toolbar.btn_clicked.connect(btn_mode_changed)
	$panel/grid.btn_clicked.connect(btn_mode_changed)
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

func btn_mode_changed(id: String):
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
		mode_changed.emit(mode)
	if split[1] == "terrain":
		terrain_idx = int(split[2])
		palette_index_changed.emit(terrain_idx)
		

	pass
