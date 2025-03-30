class_name PresetTree extends Tree

var character_presets: Dictionary
var npc_presets: Dictionary
var character_root: TreeItem 
var npc_root: TreeItem
@export var parent: Control
# Called when the node enters the scene tree for the first time.
func _ready():
	load_bestiary()
	var root: TreeItem = self.create_item()
	root.set_text(0, "Presets")
	character_root = self.create_item()
	character_root.set_text(0, "Characters")
	npc_root = self.create_item()
	npc_root.set_text(0, "NPCs")
	populate_tree()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	custom_minimum_size = parent.custom_minimum_size
	size = parent.size
	pass

func populate_tree():
	populate_leaves(character_root, character_presets)
	populate_leaves(npc_root, npc_presets)
		
func populate_leaves(parent: TreeItem, presets: Dictionary):
	for item in presets:
		var newItem: TreeItem = self.create_item(parent)
		newItem.set_text(0, item)

func get_selected_preset():
	var selected: TreeItem = self.get_selected()
	
	if selected == null:
		return null

	var parent: TreeItem = selected.get_parent()
	
	if parent.get_text(0) == "Characters":
		return character_presets[selected.get_text(0)]
	elif parent.get_text(0) == "NPCs":
		return npc_presets[selected.get_text(0)]

func load_presets():
	var save_game = FileAccess.open("res://presets/character_presets.json", FileAccess.READ)
	var json_string = save_game.get_as_text()
	var json: JSON = JSON.new()
	var parse = json.parse(json_string)
	var data: Dictionary = json.get_data()
	for k in data:
		if k == "characters":
			load_preset(character_presets, data[k])
		elif k == "npc":
			load_preset(npc_presets, data[k])
	pass

func load_bestiary():
	var bestiary = FileAccess.open("res://presets/bestiary.json", FileAccess.READ)
	var objects = bestiary.get_as_text()
	var json: JSON = JSON.new()
	json.parse(objects)
	
	var data = json.get_data()
	
	for object in data:
		load_creature(object)
	
func load_creature(creature: Dictionary):
	var statblock: StatBlock = StatBlock.new(creature)
	npc_presets[statblock.get_value("name")] = statblock
		

func load_preset(dict: Dictionary, data: Dictionary):
	for k in data:
		var details: Details = Details.new()
		details.load(data[k])
		dict[k] = details
	
	
