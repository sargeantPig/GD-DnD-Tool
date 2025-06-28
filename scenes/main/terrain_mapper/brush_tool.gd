## Brush Cursor that displays the preview and handles manages brush type and cell painting
class_name GhostBrush extends Sprite2D

enum BrushTypes {
	Quad,
	Circle
}

var palette_index: int
var palette_coord: Vector2
var selected_index: int = 0
var mouse_offset: Vector2
var console: Console
var brush: Array = [TileCell.new(Vector3.ZERO, Vector2.ZERO)]
var brushes: Brushes
var diameter: int = 1
var width: int = 1
var height: int = 1
var brush_type: BrushTypes = BrushTypes.Quad
var parent: WorldCanvas
var eraser: bool = false
var border_only: bool = false

func _ready():
	parent = get_parent()
	brushes = Brushes.new()
	self.region_enabled = true
	self.region_rect = Rect2(0, 0, 32, 32)
	scale = Vector2(1, 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("increase_brush_size"):
		_change_brush(__construct_brush_payload(1))
	if event.is_action_pressed("decrease_brush_size"):
		_change_brush(__construct_brush_payload(-1))
	if event.is_action_pressed("borders"):
		border_only = !border_only
		_change_brush(__construct_brush_payload(0))
	if event.is_action_pressed("circle_brush"):
		brush_type = BrushTypes.Circle
		_change_brush(__construct_brush_payload(0))
	if event.is_action_pressed("quad_brush"):
		brush_type = BrushTypes.Quad
		_change_brush(__construct_brush_payload(0))
	if event.is_action_pressed("rotate_brush"):
		_rotate_brush()

func __construct_brush_payload(mod: int):
	match brush_type:
		BrushTypes.Quad: 
			width += mod
			height += mod
			return {"type": brush_type, "width": width, "height": height, "border": border_only}
		BrushTypes.Circle: 
			diameter += mod*2
			return {"type": brush_type, "diameter": diameter, "border": border_only}

func _process(_delta):
	var tile_coord: Vector2 = parent.get_tilemap_coord()
	position = tile_coord

func _rotate_brush():
	## loop through vectors * by rotation matrix
	var center = Vector2.ZERO
	var count = 0

	for cell in brush:
		center += cell.cell_coord
		count += 1

	if count > 0:
		center /= count

	var angle = deg_to_rad(90)
	for cell in brush:
		var rel_x = cell.x - center.x
		var rel_y = cell.y - center.y
		var rotated_x = rel_x * cos(angle) - rel_y * sin(angle)
		var rotated_y = rel_x * sin(angle) + rel_y * cos(angle)
		cell.x = round(rotated_x + center.x)
		cell.y = round(rotated_y + center.y)
	__refresh_brush()

func _change_brush(payload: Dictionary):
	payload["border"] = border_only
	__clear_brush()
	brush_type = payload["type"]
	match payload["type"]:
		BrushTypes.Quad:
			brush = brushes.quad_brush(payload)
		BrushTypes.Circle:
			brush = brushes.circle_brush(payload)
	__add_children()

func __refresh_region():
	var rect = Rect2(palette_coord.x * 32, palette_coord.y * 32, 32, 32 )
	self.region_rect = rect

func __refresh_brush():
	__clear_children()
	__refresh_region()
	__add_children()

func __add_children():
		# Get the min and max coordinates of the brush
	var min_x: int = 0
	var min_y: int = 0
	var max_x: int = 0
	var max_y: int = 0

	for cell in brush:
		min_x = min(min_x, cell.x)
		min_y = min(min_y, cell.y)
		max_x = max(max_x, cell.x)
		max_y = max(max_y, cell.y)
	
	# Calculate the width and height of the brush
	width = max_x - min_x + 1
	height = max_y - min_y + 1
	# Calculate the center of the brush
	var center_x: int = (min_x + max_x) / 2
	var center_y: int = (min_y + max_y) / 2

	var initial_got: bool = false
	for cell: TileCell in brush:
		if not initial_got:
			mouse_offset = Vector2(cell.x, cell.y)
			initial_got = true
		# if cell.is_pattern:
		# 	cell.x -= mouse_offset.x
		# 	cell.y -= mouse_offset.y
		cell.x -= center_x
		cell.y -= center_y

		if cell.z <= 1:
			add_child(__create_ghost_segment(cell))

func __create_ghost_segment(cell: TileCell) -> Sprite2D:
	var segment: Sprite2D = Sprite2D.new()
	segment.position = cell.cell_coord * 32
	segment.texture = self.texture
	segment.region_enabled = true
	segment.region_rect = self.region_rect
	if cell.is_pattern:
		segment.region_rect = cell.region
	if parent.mode == Global.Mode.eerase:
		segment.modulate = Color(0.25, 0.25, 0.25, 0.5)
	return segment

## Paints cell(s) onto a canvas depending on brush size
func paint(world: WorldCanvas, current_layer: int, mouse_tile_location: Vector2, source_id: int, atlas_coord: Vector2):
	if palette_index == 2:
		return
	for cell: TileCell in brush:
		var layer = current_layer
		if cell.z != -1:
			layer = cell.z
			world.add_layer_if_needed(layer + current_layer)
		if cell.is_pattern:
			atlas_coord = cell.atlas_coord
			world.set_cell(layer + current_layer, mouse_tile_location+cell.cell_coord, source_id, atlas_coord)
		else: world.set_cell(current_layer, mouse_tile_location+cell.cell_coord, source_id, atlas_coord)

## Erases cell(s) on the canvas depending on brush size
func erase(world: WorldCanvas, current_layer: int, mouse_tile_location: Vector2):
	for cell: TileCell in brush:
		var layer = current_layer
		if cell.z != -1:
			layer = cell.z
		world.erase_cell(layer, mouse_tile_location+cell.cell_coord)

func set_pattern_brush(cells: Dictionary):
	__clear_brush()
	for cell in cells:
		var tile = TileCell.load_from_string("%s_%s_%s" % [cell, cells[cell][0], cells[cell][1]])
		tile.is_pattern = true
		if tile.z == -1:
			tile.z = 0
		self.brush.append(tile)
	__add_children()


func update_brush(palette_index: int, palette_coord: Vector2, atlas: Texture2D):
	self.palette_index = palette_index
	self.palette_coord = palette_coord
	self.texture = atlas
	__refresh_brush()

func __clear_children():
	for child in get_children():
		child.queue_free()

func __clear_brush():
	self.brush.clear()
	self.__clear_children()

func set_console(console: Console):
	self.console = console
	console.internal_message.connect(_change_brush)
