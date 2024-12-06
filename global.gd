extends Node

enum Mode {
	eposition,
	erotation,
	escale,
	eselect,
	emulti,
	ecancel,
	epaint,
	eerase,
	ebucket,
	epicker,
	esave,
	eload,
	eflip,
	ecolour,
}

var interactives_icon_cache: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_mouse_in_rect(mousePos: Vector2, rect: Rect2 ):
	var mouseRect: Rect2 = Rect2(mousePos, Vector2.ONE)
	return rect.abs().encloses(mouseRect)

func get_texture_from_sprite(sprite: Sprite2D):
	# first we check this sprite hasn't already had it's icon cached
	var region: Rect2 = sprite.region_rect
	var key: String = str(region.position.x) + "," + str(region.position.y)

	if interactives_icon_cache.has(key):
		return interactives_icon_cache[key]

	var texture: Texture2D = sprite.texture
	var original: Image = texture.get_image()
	var region_map: Image = original.get_region(region)
	var region_texture = ImageTexture.new()
	interactives_icon_cache[key] = region_texture.create_from_image(region_map)
	return interactives_icon_cache[key]

