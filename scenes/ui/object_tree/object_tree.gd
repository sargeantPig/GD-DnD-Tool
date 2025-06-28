class_name ObjectTree extends Control

var treeItemsByID: Dictionary
var objectsByID: Dictionary
var IDs: Array[String]
var root: TreeItem

# Called when the node enters the scene tree for the first time.
func _ready():
	root = $Tree.create_item()
	root.set_text(0, "Interactables----")
	root.set_text(1, "HP")
	root.set_text(2, "Init")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func remove(id: String):
	IDs.erase(id)
	objectsByID.erase(id)
	treeItemsByID[id].free()
	treeItemsByID.erase(id)
	$Tree.queue_redraw()

func refresh(object: PlaceableObject):
	var id = object.name
	var name = object.statblock.get_value("name")
	if not treeItemsByID.has(id):
		return
	if name != "":
		treeItemsByID[id].set_text(0, name)
	else: treeItemsByID[id].set_text(0, id)
	treeItemsByID[id].set_text(1, object.statblock.get_value("hp") + "/" +  object.statblock.get_extra_data(("max_hp")))
	treeItemsByID[id].set_text(2, object.statblock.get_extra_data("initiative"))

func sort():
	if not can_be_sorted(2):
		#print("cannot be sorted")
		return
	sort_tree_by_column(2)

func can_be_sorted(column: int) -> bool:
	for child in root.get_children():
		if not child.get_text(column):
			return false
	return true

func sort_tree_by_column(column: int):
	var sorted = false
	while not sorted:
		sorted = _sort_children_by_text(root, column)

func _sort_children_by_text(item: TreeItem, column: int):
	for child in item.get_children():
		var next = child.get_next()
		var child_init = child.get_text(column)
		if not next:
			break;
		var next_init = next.get_text(column)
		if compare_item(child_init, next_init):
			var ida: int = child.get_index()
			var idb: int = next.get_index()
			swap(ida, idb)
			child.move_after(next)
			return false
	return true

func swap(indexA: int, indexB: int):
	var temp = IDs[indexB]
	IDs[indexB] = IDs[indexA]
	IDs[indexA] = temp

func compare_item(a, b):
	if not a or not b:
		return false
	a = int(a)
	b = int(b)
	return a < b

func add_interactable_to_tree(child: PlaceableObject):
	var id = child.name
	var name = child.statblock.get_value("name")
	if not is_interactable_in_tree(id):
		var newChild: TreeItem = $Tree.create_item(root)
		treeItemsByID[id] = newChild
		objectsByID[id] = child
		IDs.append(id)
		$Tree.set_selected(treeItemsByID[id], 0)
		var icon = Global.get_texture_from_sprite(child)
		newChild.set_icon(0, icon)
		self.refresh(child)

func is_interactable_in_tree(id: String) -> bool:
	if treeItemsByID.has(id):
		$Tree.set_selected(treeItemsByID[id], 0)
		$Tree.queue_redraw()
		return true
	return false

func _on_tree_item_selected():
	var selected:  TreeItem = $Tree.get_selected()
	var index = selected.get_index()
	
	if len(IDs) == 0:
		return
	
	var id = IDs[index]
	var object: PlaceableObject = objectsByID[id]
	object.interactable.select()
	pass # Replace with function body.
