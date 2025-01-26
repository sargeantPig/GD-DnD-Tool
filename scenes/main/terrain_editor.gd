class_name WorldCanvas extends TileMap

var current_layer: int = 0
var source_id: int = 1
var palette_coord: Vector2 = Vector2(0,0)
var mouse_tile_location: Vector2
@export var parent: AppRoot
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_tile_location = get_mouse_location_on_map()
	display_ghost_tile()

func interaction(mode: Global.Mode):
	if Input.is_action_pressed("select"):
		match mode:
			Global.Mode.epaint: paint_cell()
			Global.Mode.eerase: erase_cellf()
			Global.Mode.epicker: pick()

func paint_cell():
	set_cell(current_layer, mouse_tile_location, source_id, palette_coord )

func erase_cellf():
	erase_cell(current_layer, mouse_tile_location)

func pick():
	palette_coord = get_cell_atlas_coords(0, mouse_tile_location)

func add_new_layer(name: String, position: int):
	add_layer(position)
	set_layer_name(position, name)

func get_mouse_location_on_map():
	var mouse = get_local_mouse_position()
	return local_to_map(mouse)

func palette_index_changed(id: String, value: int, coord: Vector2):
	$ghost.texture = parent.atlas[value]
	parent.palette_index = value
	palette_coord = coord
	parent.name_id = id

func display_ghost_tile():
	if parent.mode == Global.Mode.epaint:
		$ghost.visible = true
	else: 
		$ghost.visible = false
	pass

func get_tilemap_coord():
	return map_to_local(mouse_tile_location)

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
