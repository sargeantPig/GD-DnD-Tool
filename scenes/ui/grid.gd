@tool
extends Control

@export var tile_size: int = 32 
var columns: int = 0
var rows: int = 0
var viewport_size: Vector2
var last_viewport_size: Vector2i
var window_size
# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport_rect().size
	last_viewport_size = viewport_size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	viewport_size = get_viewport_rect().size
	window_size = get_window().size
	columns = (viewport_size.x + 64) / 32
	rows = (viewport_size.y + 64) /32
	if not Engine.is_editor_hint():
		if Vector2i(last_viewport_size) != window_size:
			maintain_aspect_ration()
	queue_redraw()

	last_viewport_size = get_window().size
	pass

func _draw():
	for x in range(columns):
		draw_line(Vector2(x*32, 0), Vector2(x*32, viewport_size.y ), Color.BLACK)
		for y in range(rows):
			draw_line(Vector2(0, y*32), Vector2(viewport_size.x, y*32), Color.BLACK)

func maintain_aspect_ration():
	# int X = (200+13) - ((200+13) % 13) = 213 - 5 = 208;
	# we need to rescale to maintain alignment with the grid
	var width: int = get_viewport_rect().size.x
	var height: int =  get_viewport_rect().size.y
	if width % 32 != 0:
		get_window().size = Vector2(calculate_size(32, width), calculate_size(32, height))
	elif height % 32 != 0:
		get_window().size  = Vector2(calculate_size(32, width), calculate_size(32, height))
		
func calculate_size(divisor: int, current: int):
	var rem = floori(current/divisor)
	var scaled = rem * divisor
	
	return scaled
