class_name Operations

func save_pattern(terrain: WorldCanvas, filepath: String):
	DirAccess.make_dir_recursive_absolute("user://patterns/%s" % filepath.get_base_dir())
	
	var save_file = FileAccess.open("user://patterns/%s" % filepath, FileAccess.WRITE_READ)
	var data = terrain.save_pattern()
	var json = JSON.stringify(data)
	save_file.store_line(json)
	save_file.close()

func load_pattern(terrain: WorldCanvas, filepath: String):
	var save_game = FileAccess.open("user://patterns/%s" % filepath, FileAccess.READ)
	var json_string = save_game.get_as_text()
	var json = JSON.new()
	json.parse(json_string)
	var node_data = json.get_data()
	terrain.load_pattern(node_data)
	save_game.close()

func save_terrain(terrain: WorldCanvas, filepath: String):
	DirAccess.make_dir_recursive_absolute("user://saves/%s" % filepath.get_base_dir())
	
	var save_file = FileAccess.open("user://saves/%s" % filepath, FileAccess.WRITE_READ)
	var data = terrain._save()
	var json = JSON.stringify(data)
	save_file.store_line(json)
	save_file.close()

func load_terrain(terrain: WorldCanvas, filepath: String):
	terrain.clear()
	var save_game = FileAccess.open("user://saves/%s" % filepath, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		json.parse(json_string)
		var node_data = json.get_data()
		terrain.load(node_data)
	save_game.close()

func list_files(console: Console, path: String):
	var root_files = DirAccess.get_files_at("user://%s" % path)
	var directories = DirAccess.get_directories_at("user://%s" % path)
	
	root_files.append_array(directories)
	var normal = ExArray.new(root_files)
	console.receive_text(normal.join("\n"))
