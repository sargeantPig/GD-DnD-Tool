class_name WorldCanvas extends TileMap

var current_layer: int = 0
var source_id: int = 1
var palette_coord: Vector2 = Vector2(0,0)
var mouse_tile_location: Vector2
var console: Console
var brush: GhostBrush

var selected_tiles: Array = []
var is_selecting: bool = false
var selection_start_pos: Vector2
var selection_depth = 10

@export var parent: AppRoot

var onion_skin: bool = false

var mode: Global.Mode
var modulation: Color
# Called when the node enters the scene tree for the first time.
func _ready():
	brush = get_node("brush")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_tile_location = get_mouse_location_on_map()
	display_ghost_tile()
	layer_interaction()
	if onion_skin:
		apply_onion_skins()

func _unhandled_input(_event: InputEvent) -> void:
	interaction()

func selection_started():
	is_selecting = true
	selection_depth = clamp(selection_depth, 0, get_layers_count())

func tile_selection():
	for layer in range(current_layer, selection_depth+1):
		if layer >= get_layers_count():
			continue
		if get_cell_source_id(layer, mouse_tile_location) == -1:
			continue
		if selected_tiles.has(Vector3(mouse_tile_location.x, mouse_tile_location.y, layer)):
			continue
		selected_tiles.append(Vector3(mouse_tile_location.x, mouse_tile_location.y, layer))

func remove_tile_from_selection():
	for layer in range(current_layer, selection_depth+1):
		var location = Vector3(mouse_tile_location.x, mouse_tile_location.y, layer)
		if not selected_tiles.has(location):
			continue
		selected_tiles.erase(location)
	queue_redraw()

func _draw() -> void:
	if selected_tiles.size() == 0:
		return
	for tile in selected_tiles:
		var tile_world_pos = map_to_local(Vector2(tile.x, tile.y))
		draw_rect(Rect2(tile_world_pos - Vector2(16, 16), Vector2(32, 32)), Color(0.5, 0.5, 0.5, 0.5), true)

func layer_interaction():
	if Input.is_action_just_pressed("change_layer_down"):
		change_layer(-1)
	elif Input.is_action_just_pressed("change_layer_up"):
		change_layer(1)
	#if Input.is_action_just_pressed("hide_layer"):
		#hide_current_layer()
	if Input.is_action_just_pressed("onion_skin"):
		onion_skin = !onion_skin
		if not onion_skin:
			reset_onion_skin()
	queue_redraw()

func interaction():
	if Input.is_action_pressed("select") and not Input.is_action_pressed("shift"):
		match mode:
			Global.Mode.epaint: paint_cell()
			Global.Mode.eerase: erase_cellf()
			Global.Mode.epicker: pick()
	if Input.is_action_pressed("select") and Input.is_action_pressed("shift"):
		if !is_selecting:
			selection_started()
		tile_selection()
	elif Input.is_action_pressed("unselect") and Input.is_action_pressed("shift"):
		if !is_selecting:
			selection_started()
		remove_tile_from_selection()
	elif Input.is_action_just_released("select"):
		is_selecting = false

func paint_cell():
	brush.paint(self, current_layer, mouse_tile_location, source_id, palette_coord)
	#set_cell(current_layer, mouse_tile_location, source_id, palette_coord )

func erase_cellf():
	brush.erase(self, current_layer, mouse_tile_location)

func pick():
	palette_coord = get_cell_atlas_coords(0, mouse_tile_location)

func hide_current_layer():
	if current_layer <= 0:
		console.receive_text("Cannot hide layer %s" % current_layer)
		return
	console.receive_text("Layer %s hidden" % current_layer)
	set_layer_enabled(current_layer, false)
	#change_layer(-1)
	self.__clamp_layer()

func change_layer(modifier: int):
	if modifier == -1:
		hide_current_layer()
	
	if (current_layer + modifier) < 0:
		return

	current_layer += modifier
	var layer_count = get_layers_count()
	if current_layer >= layer_count:
		add_new_layer(str(layer_count), layer_count)
	elif not is_layer_enabled(current_layer):
		set_layer_enabled(current_layer, true)
	self.__clamp_layer()
	console.receive_text("Current Layer: %s" % current_layer)

func add_new_layer(name: String, position: int):
	console.receive_text("Adding new layer")
	add_layer(position)
	set_layer_name(position, name)

func add_layer_if_needed(layer_to_add: int):
	var i = 0
	var layer_count = get_layers_count()
	while layer_to_add >= layer_count:
		i += 1
		add_new_layer(str(layer_to_add + i), get_layers_count())
		change_layer(1)
		layer_count = get_layers_count()

func reset_onion_skin():
	for layer in range(get_layers_count()):
		set_layer_modulate(layer, Color(1, 1, 1, 1))

func apply_onion_skins():
	# 2/10 1 - 0.2
	for layer in range(get_layers_count()):
		var diff = current_layer - layer
		var abs_diff = abs(diff)
		var alpha: float = 1.0-(abs_diff/10.0)
		if diff == 0 or diff == 1:
			set_layer_modulate(layer, Color(1*alpha, 1*alpha, 1*alpha, 1))
			continue
		#console.receive_text("Setting layer %s to %s" % [layer, alpha])
		set_layer_modulate(layer, Color(1*alpha, 1*alpha, 1*alpha, 1))

func get_mouse_location_on_map():
	var mouse = get_local_mouse_position()
	return local_to_map(mouse)

func palette_index_changed(id: String, palette_index: int, palette_coord: Vector2):
	brush.update_brush(palette_index, palette_coord, parent.atlas[palette_index])
	parent.palette_index = palette_index
	parent.name_id = id
	self.palette_coord = palette_coord

func display_ghost_tile():
	if parent.mode == Global.Mode.epaint or parent.mode == Global.Mode.eerase:
		brush.visible = true
	else: 
		brush.visible = false
	pass

func get_tilemap_coord():
	return map_to_local(mouse_tile_location)

func __clamp_layer():
	current_layer = clamp(current_layer, 0, get_layers_count())

func set_console(console: Console):
	self.console = console
	brush.set_console(console)

func mode_changed(mode: Global.Mode):
	self.mode = mode
	
	if self.mode == Global.Mode.eerase or Global.Mode.epaint:
		brush.update_brush(parent.palette_index, self.palette_coord, parent.atlas[parent.palette_index])

func save_pattern():
	# get cell source_id from each cell selected_cells
	var tiles_to_save: Dictionary = {}

	for cell: Vector3 in selected_tiles:
		var cell_source_id = get_cell_source_id(int(cell.z), Vector2(cell.x, cell.y))
		var atlas_source: TileSetAtlasSource = self.tile_set.get_source(cell_source_id)
		var cell_atlas_coords: Vector2 = get_cell_atlas_coords(int(cell.z), Vector2(cell.x, cell.y))
		var region: Rect2 = atlas_source.get_tile_texture_region(cell_atlas_coords)
		var tilset: TileSet = self.tile_set
		var tile = TileCell.new(cell, cell_atlas_coords, region)
		tiles_to_save = Global.merge_dicts(tiles_to_save, tile.json_string())

	return tiles_to_save

func load_pattern(data: Dictionary):
	brush.set_pattern_brush(data)

func _save():
	# get the extents of used cells
	var tiles: Array[String]
	var data: Dictionary = {}
	data["object_type"] = "tilemap"
	
	for layer in range(get_layers_count()):
		var rect = self.get_used_cells(layer)
		for cell in rect:
			var tile_coords = self.get_cell_atlas_coords(layer, Vector2(cell[0], cell[1]))
			# convert tile_coords and position into strings
			# position, coords
			var key: String = "%s,%s" % [cell[0], cell[1]]
			var position: String = "%s,%s" % [tile_coords.x, tile_coords.y]
			data["tile_%s_%s" % [layer, key]] = position
	return data

func load(data):
	var layer_count = get_layers_count()
	for tile in data:
		if tile == "object_type":
			continue
		
		var splitkey = tile.split("_")
		var pos = splitkey[2].split(",")
		var tilepos = Vector2(float(pos[0]), float(pos[1]))
		var tileIndex = data[tile].split(",")
		var tilecoord = Vector2(float(tileIndex[0]), float(tileIndex[1]))
		var layer = splitkey[1]
		
		if int(layer) >= get_layers_count():
			change_layer(1)
			layer_count+=1 
		
		set_cell(int(layer), tilepos, 1, tilecoord)

func save_pattern_file(filepath: String):
	DirAccess.make_dir_recursive_absolute("user://patterns/%s" % filepath.get_base_dir())
	
	var save_file = FileAccess.open("user://patterns/%s" % filepath, FileAccess.WRITE_READ)
	var data = self.save_pattern()
	var json = JSON.stringify(data)
	save_file.store_line(json)
	save_file.close()

func load_pattern_file(filepath: String):
	var save_game = FileAccess.open("user://patterns/%s" % filepath, FileAccess.READ)
	var json_string = save_game.get_as_text()
	var json = JSON.new()
	json.parse(json_string)
	var node_data = json.get_data()
	self.load_pattern(node_data)
	save_game.close()
	return node_data

func save_terrain(filepath: String):
	DirAccess.make_dir_recursive_absolute("user://saves/%s" % filepath.get_base_dir())
	
	var save_file = FileAccess.open("user://saves/%s" % filepath, FileAccess.WRITE_READ)
	var data = self._save()
	var json = JSON.stringify(data)
	save_file.store_line(json)
	save_file.close()

func load_terrain(filepath: String):
	self.clear()
	var save_game = FileAccess.open("user://saves/%s" % filepath, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		json.parse(json_string)
		var node_data = json.get_data()
		self.load(node_data)
	save_game.close()
