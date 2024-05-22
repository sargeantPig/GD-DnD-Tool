extends Node2D

# area of effect cones, etc
# move characters
# spell ranges/ movement
# data structure for character sheets ------ longer term goal
# forestry, stone, wooden textures
# icons for effects like fire, ice, toxic, bleeding small 16x16 or 8x8

# networking in future ---- longer term

signal source_changed(source: TileSetAtlasSource)

const object_res: PackedScene = preload("res://scenes/object/object.tscn")

var selectedIndex: int = 0
var tilesets: Array = [$grassy_terrain]
@export var atlas: Array[Texture2D]
var mode: Global.Mode
var source_id: int = 1
var palette_index: int = 0
var palette_coord: Vector2 = Vector2(0,0)
var tilemap_coord: Vector2
var misc_objects: Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	$ui.palette_index_changed.connect(palette_index_changed)
	$ui.mode_changed.connect(mode_changed)
	$ui.mode_changed.connect($misc._mode_changed)
	pass

func _unhandled_input(event):
	if mode == Global.Mode.epaint:
		paint(tilemap_coord)
	if mode == Global.Mode.eerase:
		erase(tilemap_coord)
	if mode == Global.Mode.epicker:
		pick(tilemap_coord)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tilemap_coord = get_mouse_location_on_map()
	display_ghost_tile()
	mode = $ui.mode

	pass

func pick(tilemap_coord: Vector2):
	if Input.is_action_pressed("select"):
		print("picked at " + str(tilemap_coord))
		palette_coord = $grassy_terrain.get_cell_atlas_coords(0, tilemap_coord)
		print($grassy_terrain.get_cell_atlas_coords(0, tilemap_coord))
	pass

func erase(tilemap_coord: Vector2):
	if Input.is_action_pressed("select"):
		print("erase at " + str(tilemap_coord))
		$grassy_terrain.set_cell(0, tilemap_coord, source_id)

func paint(tilemap_coord: Vector2):
	if Input.is_action_pressed("select"):
		print("paint at " + str(tilemap_coord))
		match palette_index:
			0: $grassy_terrain.set_cell(0, tilemap_coord, source_id, palette_coord )
			_: pass
				
	if Input.is_action_just_released("select") && palette_index != 0:
		add_misc_object()
	print(palette_coord)
	pass


func create_object(tilemap_coord, palette_coord) -> Node2D:
	var new_object = object_res.instantiate()
	new_object.position = get_tilemap_coord()
	new_object.set_texture(atlas[palette_index])
	new_object.set_region(Rect2(palette_coord.x*32, palette_coord.y*32, 32, 32))
	new_object.set_parent(self)
	return new_object

func add_misc_object():
	$misc.add_child(create_object(tilemap_coord, palette_coord))
	
func _input(event):
	if event.is_action_pressed("tilemap_cycle_right"):
		modify_selected_index(1)
	elif event.is_action_pressed("tilemap_cycle_left"):
		modify_selected_index(-1)
	pass

func display_ghost_tile():
	if mode == Global.Mode.epaint:
		$ghost.visible = true
	else: 
		$ghost.visible = false
	pass

func palette_index_changed(value: int, coord: Vector2):
	$ghost.texture = atlas[value]
	palette_index = value
	palette_coord = coord
	print(str(value) + " recieved")
	print(str(coord) + " recieved")

func get_mouse_location_on_map():
	var mouse = get_local_mouse_position()
	var tilemap_coord = $grassy_terrain.local_to_map(mouse)
	return tilemap_coord

func mode_changed(value: Global.Mode):
	mode = value

func modify_selected_index(value: int):
	selectedIndex = clampi(selectedIndex + value,  0, tilesets.size()-1)
	pass

func get_tileset_atlas():
	return $grassy_terrain.tile_set.get_source(source_id)

func get_palette_coord():
	return palette_coord
	
func get_tilemap_coord():
	return $grassy_terrain.map_to_local(tilemap_coord)
