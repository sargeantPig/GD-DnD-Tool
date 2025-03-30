class_name ObjectManager extends Node2D

signal mode_change(mode: Global.Mode)

var selected_objects: Array
var parent: Node2D
var selected_object: PlaceableObject
var object_details: ObjectContext
var object_tree: ObjectTree
# Called when the node enters the scene tree for the first time.
func _ready():
	# We need tp get the object details box
	parent = get_parent()
	object_details = parent.get_ui_object_details()
	object_tree = parent.get_ui_object_tree()
	object_details.connected_tree = object_tree
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
	for child in get_children() as Array[PlaceableObject]:
		if child.name != id:
			child.interactable.selected = false
		else: 
			selected_object = child
			object_details.set_stats(child.statblock)
			object_details.connected_object = child
			object_tree.add_interactable_to_tree(child)
	pass

func select_objects(box: Rect2):
	selected_objects.clear()
	var children = get_children()
	for child in children:
		var child_rect = child.get_loc_rect()
		child.orig_pos = child.position
		if box.abs().encloses(child_rect):
			selected_objects.append(child)

func get_last():
	var children = get_children() as Array[PlaceableObject]
	return children[children.size() - 1].name

# Move group of object, keeping relative positions
func move_group(mouse_pos: Vector2):
	var current_mouse_pos = get_local_mouse_position()
	for obj in selected_objects:
		var diff = current_mouse_pos - mouse_pos
		obj.position = obj.orig_pos + diff

func _mode_changed(mode: Global.Mode):
	mode_change.emit(mode)
