class_name Brushes

func quad_brush(payload: Dictionary):
	var brush_cells: Array = []
	var width = int(payload["width"])
	var height = int(payload["height"])
	for x in range(width):
		for y in range(height):
			if payload["border"] and x != width-1 and y != height-1 and x != 0 and y != 0:
				continue
			brush_cells.append(Vector2(x, y))
			if x == 0 and y == 0:
				continue
	return brush_cells

func circle_brush(payload: Dictionary):
	var brush_cells: Array = []
	var diameter = payload["diameter"]
	var radius = diameter*0.5
	if diameter == 0:
		brush_cells.append(Vector2(0,0))
		return brush_cells
	
	for x in range(-diameter, diameter):
		for y in range(-diameter, diameter):
			if not vertex_in_circle(Vector2(x, y), radius):    # not Vector2(x, y).distance_squared_to(Vector2.ZERO) <= diameter:
				continue
			if (payload["border"] and vertex_not_on_border(Vector2(x,y), radius)):
				continue
			brush_cells.append(Vector2(x, y))
			if x == 0 and y == 0:
				continue
	return brush_cells

### Check four points of square on grid is within a circle
func vertex_in_circle(coord: Vector2, radius: int) -> bool:
	var cell_center: Vector2 = coord + Vector2(1.0/2.0, 1.0/2.0)
	return cell_center.distance_to(Vector2.ZERO) <= radius

func vertex_not_on_border(coord: Vector2, radius: int):
	var cell_center = coord + Vector2(1.0/2.0, 1.0/2.0)
	var distance = cell_center.distance_to(Vector2.ZERO)
	return abs(distance - radius) >= 1.0
	
