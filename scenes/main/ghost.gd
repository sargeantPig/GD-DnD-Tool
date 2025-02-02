extends Sprite2D

var source_texture: Texture2D 

var selected_index: int = 0

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
	pass
