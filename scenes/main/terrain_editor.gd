class_name WorldCanvas extends TileMap

var current_layer: int = 0
var source_id: int = 1
var palette_coord: Vector2 = Vector2(0,0)
var mouse_tile_location: Vector2
var console: Console
@export var parent: AppRoot

var onion_skin: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_tile_location = get_mouse_location_on_map()
	display_ghost_tile()
	if onion_skin:
		apply_onion_skins()

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

func interaction(mode: Global.Mode):
	if Input.is_action_pressed("select"):
		match mode:
			Global.Mode.epaint: paint_cell()
			Global.Mode.eerase: erase_cellf()
			Global.Mode.epicker: pick()

func paint_cell():
	$ghost.paint(self, current_layer, mouse_tile_location, source_id, palette_coord)
	#set_cell(current_layer, mouse_tile_location, source_id, palette_coord )

func erase_cellf():
	erase_cell(current_layer, mouse_tile_location)

func pick():
	palette_coord = get_cell_atlas_coords(0, mouse_tile_location)

func hide_current_layer():
	if current_layer == 0:
		console.receive_text("Cannot hide layer %s" % current_layer)
		return
	console.receive_text("Layer %s hidden" % current_layer)
	set_layer_enabled(current_layer, false)
	#change_layer(-1)
	self.__clamp_layer()

func change_layer(modifier: int):
	if modifier == -1:
		hide_current_layer()
	current_layer += modifier
	console.receive_text("Current Layer: %s" % current_layer)
	var layer_count = get_layers_count()
	if current_layer >= layer_count:
		add_new_layer(str(layer_count), layer_count)
	elif not is_layer_enabled(current_layer):
		set_layer_enabled(current_layer, true)
	self.__clamp_layer()

func add_new_layer(name: String, position: int):
	console.receive_text("Adding new layer")
	add_layer(position)
	set_layer_name(position, name)

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
		set_layer_modulate(layer, Color(1*alpha, 1*alpha, 1*alpha, 1*alpha))

func get_mouse_location_on_map():
	var mouse = get_local_mouse_position()
	return local_to_map(mouse)

func palette_index_changed(id: String, value: int, coord: Vector2):
	$ghost.texture = parent.atlas[value]
	parent.palette_index = value
	parent.name_id = id
	palette_coord = coord

func display_ghost_tile():
	if parent.mode == Global.Mode.epaint:
		$ghost.visible = true
	else: 
		$ghost.visible = false
	pass

func get_tilemap_coord():
	return map_to_local(mouse_tile_location)

func __clamp_layer():
	current_layer = clamp(current_layer, 0, get_layers_count())

func set_console(console: Console):
	self.console = console
	$ghost.set_console(console)

func _save():
	# get the extents of used cells
	var layer: int = 0
	var rect = self.get_used_rect()
	var tiles: Array[String]
	var data: Dictionary = {}
	data["object_type"] = "tilemap"
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			var tile_coords = self.get_cell_atlas_coords(layer, Vector2(x, y))
			# convert tile_coords and position into strings
			# position, coords
			var key: String = "%s,%s" % [x, y]
			var position: String = "%s,%s" % [tile_coords.x, tile_coords.y]
			data["tile_%s" % [key]] = position
	return data
	pass

func load(data):
	for tile in data:
		if tile == "object_type":
			continue
		var splitkey = tile.split("_")
		var pos = splitkey[1].split(",")
		var tilepos = Vector2(float(pos[0]), float(pos[1]))
		var tileIndex = data[tile].split(",")
		var tilecoord = Vector2(float(tileIndex[0]), float(tileIndex[1]))
		set_cell(0, tilepos, 1, tilecoord)
