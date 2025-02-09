class_name GhostBrush extends Sprite2D

var source_texture: Texture2D 
var selected_index: int = 0
var mouse_offset: Vector2
var console: Console
var brush: Array = []

func _ready():
	self.region_enabled = true
	self.region_rect = Rect2(0, 0, 32, 32)
	scale = Vector2(1, 1)

	pass

func _process(delta):
	var parent = get_parent()
	var coord: Vector2 = parent.palette_coord
	var tile_coord: Vector2 = parent.get_tilemap_coord()
	var rect = Rect2(coord.x * 32, coord.y * 32, 32, 32 )
	self.region_rect = rect
	position = tile_coord

func _change_brush(payload: Dictionary):
	match payload["type"]:
		"quad_brush":
			quad_brush(payload)

func quad_brush(payload: Dictionary):
	self.__clear_brush()
	for x in range(int(payload["width"])):
		for y in range(int(payload["height"])):
			brush.append(Vector2(x, y))
			if x == 0 and y == 0:
				continue
			add_child(self.__create_ghost_segment(x * 32, y * 32))

func __create_ghost_segment(x: int, y: int):
	var segment: Sprite2D = Sprite2D.new()
	segment.position = Vector2(x, y)
	segment.texture = self.texture
	segment.region_enabled = true
	segment.region_rect = self.region_rect
	return segment

func paint(world: WorldCanvas, current_layer: int, mouse_tile_location: Vector2, source_id: int, palette_coord: Vector2):
	for cell in brush:
		world.set_cell(current_layer, mouse_tile_location+cell, source_id, palette_coord)

func __clear_brush():
	for child in get_children():
		child.queue_free()

func set_console(console: Console):
	self.console = console
	console.internal_message.connect(_change_brush)
