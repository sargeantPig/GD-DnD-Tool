class_name PatternTree extends Tree

var pattern_cache: Dictionary
var pattern_root: TreeItem 
@export var parent: Control
@export var world_canvas: WorldCanvas
# Called when the node enters the scene tree for the first time.
func _ready():
	load_patterns()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	custom_minimum_size = parent.custom_minimum_size
	size = parent.size
	pass

func _set_roots():
	var root: TreeItem = self.create_item()
	root.set_text(0, "Presets")
	pattern_root = self.create_item()
	pattern_root.set_text(0, "Patterns")

func get_selected_preset():
	var selected: TreeItem = self.get_selected()
	
	if selected == null:
		return null

	var pattern_name = selected.get_text(0)
	
	if not pattern_cache.has(pattern_name):
		return null
	
	if pattern_cache[pattern_name] != null:
		world_canvas.load_pattern((pattern_cache[pattern_name]))
		return pattern_cache[pattern_name]
	
	pattern_cache[pattern_name] = world_canvas.load_pattern_file(pattern_name)
	return pattern_cache[pattern_name]

func populate_leaves(root: TreeItem, presets: Dictionary):
	for item in presets:
		var newItem: TreeItem = self.create_item(root)
		newItem.set_text(0, item)

func load_patterns():
	pattern_cache.clear()
	self.clear()
	_set_roots()

	var pattern_folder = DirAccess.open("user://patterns/")
	
	if not pattern_folder:
		return
	var _files = pattern_folder.get_files()

	for file in _files:
		add_pattern_file_to_cache(file)
	
	populate_leaves(pattern_root, pattern_cache)

func add_pattern_file_to_cache(file: String):
	pattern_cache[file] = null

func refresh_trigger():
	load_patterns()

func load_preset(dict: Dictionary, data: Dictionary):
	for k in data:
		var details: Details = Details.new()
		details.load(data[k])
		dict[k] = details

func _on_item_selected() -> void:
	get_selected_preset()
	pass # Replace with function body.
