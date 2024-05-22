@tool
extends Control


@export var tile_size: int = 32 
var columns: int = 0
var rows: int = 0
var viewport_size: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	viewport_size = get_viewport_rect().size
	columns = (viewport_size.x + 64) / 32
	rows = (viewport_size.y +64) /32
	queue_redraw()
	pass

func _draw():
	for x in range(columns):
		draw_line(Vector2(x*32, 0), Vector2(x*32, viewport_size.y ), Color.BLACK)
		for y in range(rows):
			draw_line(Vector2(0, y*32), Vector2(viewport_size.x, y*32), Color.BLACK)
