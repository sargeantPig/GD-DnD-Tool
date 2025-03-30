extends Node
func create_placeable_object(object_res: PackedScene, parameters: Dictionary):
	var new_object: PlaceableObject = object_res.instantiate()
	new_object.position =  parameters["tilemap_coord"]
	new_object.visual.atlas_index = parameters["palette_index"]
	new_object.set_texture(parameters["atlas"])
	new_object.set_region(parameters["region"])
	new_object.set_parent(parameters["parent"])
	new_object.mode = parameters["mode"]
	if parameters["preset"] != null:
		new_object.statblock = StatBlock.new({}).load_from_block(parameters["preset"])
	#	new_object.set_real_name()
	return new_object
