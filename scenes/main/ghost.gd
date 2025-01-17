extends Sprite2D

var source_texture: Texture2D 

var selected_index: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	self.region_enabled = true
	self.region_rect = Rect2(0, 0, 32, 32)
	scale = Vector2(1, 1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent()
	var coord: Vector2 = parent.get_palette_coord()
	var tile_coord: Vector2 = parent.get_tilemap_coord()
	var rect = Rect2(coord.x * 32, coord.y * 32, 32, 32 )
	
	self.region_rect = rect
	#var source = parent.get_tileset_atlas()
	#source_texture = source.get_runtime_texture()
	#self.texture = source_texture
	position = tile_coord
	pass
