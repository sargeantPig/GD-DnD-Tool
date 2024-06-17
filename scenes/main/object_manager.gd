extends Node2D

signal mode_change(mode: Global.Mode)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_count_by_name(name: String):
	var count = -1
	var children = get_children()
	for child in children:
		if child.id == name:
			count += 1
	return count

func _managed_object_selected(id: String):
	for child in get_children():
		if child.name != id:
			child.selected = false
	pass

func _mode_changed(mode: Global.Mode):
	mode_change.emit(mode)


