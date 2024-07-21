class_name Visual

var atlas_index: int = 0
var selected: bool = false
var original_position: Vector2

func set_atlas(atlas_ind: int):
	self.atlas_index = atlas_ind

func toggle_selected():
	self.selected = !selected

func save():
	var data = {
		"atlas_index": atlas_index,
	}
	return data

func load(data):
	atlas_index = data["atlas_index"]
	
