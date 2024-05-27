extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _save():
	# get the extents of used cells
	var layer: int = 0
	var rect = self.get_used_rect()
	var tiles: Array[String]
	var data: Dictionary = {}
	data["object_type"] = "tilemap"
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			var tile_coords = self.get_cell_atlas_coords(layer, Vector2(x, y))
			# convert tile_coords and position into strings
			# position, coords
			var key: String = "%s,%s" % [x, y]
			var position: String = "%s,%s" % [tile_coords.x, tile_coords.y]
			data["tile_%s" % [key]] = position
	return data
	pass

func load(data):
	for tile in data:
		if tile == "object_type":
			continue
		var splitkey = tile.split("_")
		var pos = splitkey[1].split(",")
		var tilepos = Vector2(float(pos[0]), float(pos[1]))
		var tileIndex = data[tile].split(",")
		var tilecoord = Vector2(float(tileIndex[0]), float(tileIndex[1]))
		set_cell(0, tilepos, 1, tilecoord)
