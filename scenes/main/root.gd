class_name AppRoot extends Node2D

# area of effect cones, etc
# move characters	
# spell ranges/ movement
# data structure for character sheets ------ longer term goal
# forestry, stone, wooden textures
# icons for effects like fire, ice, toxic, bleeding small 16x16 or 8x8

# networking in future ---- longer term

signal source_changed(source: TileSetAtlasSource)

const object_res: PackedScene = preload("res://scenes/placeable_object/placeable_object.tscn")

@export var server: Server
@export var atlas: Array[Texture2D]
@export var world_canvas: WorldCanvas
var selectedIndex: int = 0
var tilesets: Array = []
var mode: Global.Mode
var source_id: int = 1
var palette_index: int = 0
var name_id: String
var misc_objects: Array[Node2D]
var multi_pos: Vector2
var multi_rect: Rect2
var multi_mouse_pos: Vector2
var ticker: Ticker
var colourPicker: ColorPickerButton

# ONE SHOT VARS

var object_manager: ObjectManager
var presets: PresetTree
var fps: float

func _ready():
	$canvas/ui.palette_index_changed.connect(world_canvas.palette_index_changed)
	$canvas/ui.mode_changed.connect(mode_changed)
	$canvas/ui.mode_changed.connect($misc._mode_changed)
	object_manager = $misc
	ticker = Ticker.new(0.5)
	presets = $canvas/ui/TabContainer/preset_tree
	colourPicker = $canvas/colour_pick
	server.set_console($canvas/ui/console)
	pass

func _unhandled_input(event):
	match palette_index:
		0: world_canvas.interaction(mode)
	if mode == Global.Mode.epaint:
		paint()
	if mode == Global.Mode.emulti:
		multi_select()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mode = $canvas/ui.mode
	ticker._process(delta)
	pass

func _draw():
	if Input.is_action_pressed("select") && !Global.check_mouse_in_rect(get_local_mouse_position(), multi_rect):
		var size_vect = multi_pos - get_local_mouse_position()
		multi_rect = Rect2(multi_pos, -size_vect)
		draw_rect(multi_rect, Color(0.1, 0.1, 0.5, 0.3), true)
	else: draw_rect(multi_rect, Color(0.1, 0.1, 0.5, 0.1), true)

func multi_select():
	var is_in_multi = Global.check_mouse_in_rect(get_local_mouse_position(), multi_rect)
	if is_in_multi && Input.is_action_just_pressed("select"):
		multi_mouse_pos = get_local_mouse_position()
	if is_in_multi && Input.is_action_pressed("select"):
		$misc.move_group(multi_mouse_pos)
		var diff = get_local_mouse_position() - multi_mouse_pos
		multi_rect.position = multi_pos + diff
		queue_redraw()
		return
	if Input.is_action_just_pressed("select"):
		multi_pos = get_local_mouse_position()
	if Input.is_action_just_released("select"):
		multi_pos = multi_rect.position
		$misc.select_objects(multi_rect)
	queue_redraw()

func paint():
	if Input.is_action_just_released("select") && palette_index != 0 && ticker.ticked:
		add_misc_object()
		ticker.start()
	pass

func create_object() -> Node2D:
	var params = {
		"name_id": name_id,
		"tilemap_coord": world_canvas.get_tilemap_coord(),
		"palette_index": palette_index,
		"atlas": atlas[palette_index],
		"region": Rect2(world_canvas.palette_coord.x*32, world_canvas.palette_coord.y*32, 32, 32),
		"parent": $misc,
		"mode": mode,
		"preset": presets.get_selected_preset()
	}
	return ObjectFactory.create_placeable_object(object_res, params)

func add_misc_object():
	object_manager.add_child(create_object())
	object_manager._managed_object_selected(object_manager.get_last())

func _input(event):
	if event.is_action_pressed("tilemap_cycle_right"):
		modify_selected_index(1)
	elif event.is_action_pressed("tilemap_cycle_left"):
		modify_selected_index(-1)
	pass

func flip():
	if object_manager.selected_object != null:
		object_manager.selected_object.flip()

func mod_colour():
	if object_manager.selected_object != null:
		var picker: ColorPicker = colourPicker.get_picker()
		object_manager.selected_object.visual.orig_modulation = picker.color

func mode_changed(value: Global.Mode):
	# Check for one shot modes, like saving and loading
	match(value):
		Global.Mode.esave: 
			_save_objects()
		Global.Mode.eload:
			_load_objects()
		Global.Mode.eflip:
			flip()
			return
		Global.Mode.ecolour:
			mod_colour()
			return
	
	mode = value

func modify_selected_index(value: int):
	selectedIndex = clampi(selectedIndex + value,  0, tilesets.size()-1)
	pass

func get_tileset_atlas():
	return world_canvas.tile_set.get_source(source_id)

func get_ui_object_details():
	return $canvas/ui/object_details

func get_ui_object_tree():
	return $canvas/ui/object_tree

func _save_objects():
	var path = "dnd_saves"
	var tosave: Array[Node] = get_tree().get_nodes_in_group("can_save")

	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	for item in tosave:
		var data = item._save()
		var json = JSON.stringify(data)
		save_file.store_line(json)
	save_file.close()
	pass
	
func _load_objects():
	if not FileAccess.file_exists("user://savegame.save"):
		return 
	
	# Clear the terrain
	world_canvas.clear()
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for i in save_nodes:
		i.queue_free()
		
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		match(node_data["object_type"]):
			"item": _load_item(node_data)
			"tilemap": world_canvas.load(node_data)
	pass
	
func _load_item(data):
	var new_object: Node = load(data["filename"]).instantiate()
	new_object.set_parent(object_manager)
	new_object.set_texture(atlas[data["atlas"]["atlas_index"]])
	new_object.load(data)
	$misc.add_child(new_object)
	object_manager.object_tree.add_interactable_to_tree(new_object)
