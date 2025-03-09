extends Camera2D

var horizontal = Vector2(32, 0)
var vertical = Vector2(0, 32)
@export var tile_size: int = 32 
var columns: int = 0
var rows: int = 0
var viewport_size: Vector2
var last_viewport_size: Vector2
var last_zoom_level: float
var window_size
var grid_lines: Array = []
var conv_zoom: float
var first_draw: bool = false
var ticker: Ticker
var zoom_max = Vector2(2.0, 2.0)
var zoom_min = Vector2(0.3, 0.3)
var zoom_step = Vector2(0.1, 0.1)
var scroll_mod: int = 1
var fps: float
var font: Font
# Called when the node enters the scene tree for the first time.
func _ready():
	font = Control.new().get_theme_font("font")
	viewport_size = get_viewport_rect().size
	last_viewport_size = viewport_size
	last_zoom_level = zoom.x
	ticker = Ticker.new(0.1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps = round(1000/delta)
	viewport_size = get_viewport_rect().size
	window_size = get_window().size
	var zoom_level = zoom.x
	conv_zoom = 1 / zoom.x
	columns = int((viewport_size.x / tile_size) + 2) * conv_zoom 
	rows = int((viewport_size.y / tile_size) + 2) * conv_zoom
	
	if viewport_size != last_viewport_size or zoom_level != last_zoom_level or not first_draw:
		update_grid_lines()
		first_draw = true
	
	queue_redraw()
	
	last_viewport_size = viewport_size
	last_zoom_level = zoom_level
	
	if not Engine.is_editor_hint():
		inputs(delta)
	pass

func inputs(delta):
	ticker._process(delta)
	if not ticker.ticked:
		return
	if Input.is_action_pressed("shift"):
		scroll_mod = 2
	else: scroll_mod = 1
	if Input.is_action_pressed("move_left"):
		ticker.start()
		position += -horizontal * scroll_mod
	if Input.is_action_pressed("move_right"):
		ticker.start()
		position += horizontal * scroll_mod
	if Input.is_action_pressed("move_up"):
		ticker.start()
		position += vertical * scroll_mod
	if Input.is_action_pressed("move_down"):
		ticker.start()
		position += -vertical * scroll_mod
	if Input.is_action_pressed("zoom_in"):
		ticker.start()
		zoom += zoom_step * scroll_mod
		zoom = clamp(zoom, zoom_min, zoom_max)
	if Input.is_action_pressed("zoom_out"):
		ticker.start()
		zoom -= zoom_step * scroll_mod
		zoom = clamp(zoom, zoom_min, zoom_max)

func _draw():
	for line in grid_lines:
		draw_line(line[0], line[1], Color.BLACK)
	draw_string(font, Vector2(170,15), str(Engine.get_frames_per_second()), HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color("green")  )

func update_grid_lines():
	grid_lines.clear()
	var zoom_level = zoom.x
	var scaled_tile_size = tile_size * zoom_level
	for x in range(columns):
		var x_pos = x * tile_size
		grid_lines.append([Vector2(x_pos, 0), Vector2(x_pos, viewport_size.y * conv_zoom)])
	for y in range(rows):
		var y_pos = y * tile_size
		grid_lines.append([Vector2(0, y_pos), Vector2(viewport_size.x * conv_zoom, y_pos)])

func maintain_aspect_ratio():
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
