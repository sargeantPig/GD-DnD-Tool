extends Node2D

signal mode_change(mode: Global.Mode)

var selected_objects: Array

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
			child.interactable.selected = false
	pass

func select_objects(box: Rect2):
	selected_objects.clear()
	var children = get_children()
	for child in children:
		var child_rect = child.get_loc_rect()
		child.orig_pos = child.position
		if box.abs().encloses(child_rect):
			selected_objects.append(child)
			print(child.name, " added to multi select")

# Move group of object, keeping relative positions
func move_group(mouse_pos: Vector2):
	var current_mouse_pos = get_local_mouse_position()
	for obj in selected_objects:
		var diff = current_mouse_pos - mouse_pos
		obj.position = obj.orig_pos + diff
		
	

func _mode_changed(mode: Global.Mode):
	mode_change.emit(mode)


