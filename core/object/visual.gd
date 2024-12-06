class_name Visual

var atlas_index: int = 0
var original_position: Vector2
var orig_modulation: Color

func _init(modulation: Color):
	self.orig_modulation = modulation

func refresh(is_selected: bool, sprite: Sprite2D):
	if is_selected:
		sprite.modulate = orig_modulation
		sprite.modulate.a = 0.5
	else: sprite.modulate = orig_modulation

func set_atlas(atlas_ind: int):
	self.atlas_index = atlas_ind

func save():
	var data = {
		"atlas_index": atlas_index,
	}
	return data

func load(data):
	atlas_index = data["atlas_index"]
	
