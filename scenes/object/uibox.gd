extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save():
	var data = {
		"name": $lbl_name.text,
		"health": $ScrollContainer/VBoxContainer/input_health.text,
		"status": $ScrollContainer/VBoxContainer/input_status.text,
		"notes": $ScrollContainer/VBoxContainer/input_notes.text
	}
	return data

func load(data):
	$lbl_name.clear()
	for key in data:
		match(key):
			"name": $lbl_name.text = data[key]
			"health": $ScrollContainer/VBoxContainer/input_health.text = data[key]
			"status": $ScrollContainer/VBoxContainer/input_status.text = data[key]
			"notes": $ScrollContainer/VBoxContainer/input_notes.text = data[key]
	pass
