class_name TileCell

var tilemap_cell_coord: Vector3
var atlas_coord: Vector2
var region: Rect2
var is_pattern: bool = false

func _init(coord: Vector3, atlas: Vector2, rect: Rect2 = Rect2() , am_pattern: bool = false) -> void:
	self.tilemap_cell_coord = coord
	self.atlas_coord = atlas
	self.is_pattern = am_pattern
	self.region = rect

static func load_from_string(cell: String) -> TileCell:
	var split = cell.split("_")
	var coord_split = split[0].split(",")
	var atlas_split = split[1].split(",")
	var region_split = split[2].split(",")
	var _region = Rect2(float(region_split[0]), float(region_split[1]), float(region_split[2]), float(region_split[3]))
	var coord = Vector3(float(coord_split[0]), float(coord_split[1]), float(coord_split[2]))
	var atlas = Vector2(float(atlas_split[0]), float(atlas_split[1]))
	return TileCell.new(coord, atlas, _region)

func json_string() -> Dictionary:
	var cell_coord_key = "%s,%s,%s" % [tilemap_cell_coord.x, tilemap_cell_coord.y, tilemap_cell_coord.z]
	var atlas_coord_value = "%s,%s" % [atlas_coord.x, atlas_coord.y]
	var region_coord = "%s,%s,%s,%s" % [region.position.x, region.position.y, region.size.x, region.size.y]
	return {cell_coord_key: [atlas_coord_value, region_coord]}

@export var cell_coord: Vector2:
	get:
		return Vector2(tilemap_cell_coord.x, tilemap_cell_coord.y)

@export var x: int:
	get:
		return int(tilemap_cell_coord.x)

@export var y: int:
	get:
		return int(tilemap_cell_coord.y)

@export var z: int:
	get:
		return int(tilemap_cell_coord.z)
