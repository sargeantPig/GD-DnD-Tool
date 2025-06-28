class_name LoadTree extends Tree

signal file_selected(filename)

var save_files: Array
var save_root: TreeItem 
@export var parent: Control
# Called when the node enters the scene tree for the first time.
func _ready():
	self.focus_mode = Control.FOCUS_NONE
	load_saves()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	custom_minimum_size = parent.custom_minimum_size
	size = parent.size
	pass

func get_selected_preset():
	var selected: TreeItem = self.get_selected()
	
	if selected == null:
		return null

	var save_name = selected.get_text(0)
	file_selected.emit(save_name)
	#world_canvas.load_terrain(save_name)

func _set_roots():
	var root: TreeItem = self.create_item()
	root.set_text(0, "Presets")
	save_root = self.create_item()
	save_root.set_text(0, "Maps")

func populate_leaves(root: TreeItem, presets: Array):
	for item in presets:
		var newItem: TreeItem = self.create_item(root)
		newItem.set_text(0, item)

func load_saves():
	self.clear()
	save_files.clear()
	_set_roots()
	var pattern_folder = DirAccess.open("user://saves/")
	
	if not pattern_folder:
		return
	var _files = pattern_folder.get_files()

	for file in _files:
		save_files.append(file)
	
	populate_leaves(self.save_root, save_files)

func _on_item_selected() -> void:
	get_selected_preset()
	pass # Replace with function body.
