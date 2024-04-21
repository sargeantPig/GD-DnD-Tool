extends Node2D

var mode: Global.Mode
# Called when the node enters the scene tree for the first time.
func _ready():
	$toolbar.btn_clicked.connect(btn_mode_changed)
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
	if id.split("_")[1] == "tool":
		match(id):
			"btn_rotate": mode = Global.Mode.erotation
			"btn_move": mode = Global.Mode.eposition
			"btn_select": mode = Global.Mode.eselect
			"btn_multiselect": mode = Global.Mode.emulti
			"btn_resize": mode = Global.Mode.escale
			"btn_cancel": mode = Global.Mode.ecancel
	if id.split("_")[1] == "terrain":
		match(id):
			"btn_rotate": mode = Global.Mode.erotation
			"btn_move": mode = Global.Mode.eposition
			"btn_select": mode = Global.Mode.eselect
			"btn_multiselect": mode = Global.Mode.emulti
			"btn_resize": mode = Global.Mode.escale
			"btn_cancel": mode = Global.Mode.ecancel
	print(mode)
	pass
