class_name ConsoleCommands

var __error_message: Dictionary = {"ERROR": "Invalid Paramaters\n %s"}

func process_command(cmd: String) -> Dictionary:
	var params: Array = cmd.split(" ")
	match params[0]:
		"roll":
			return __roll_payload(params)
		"server":
			return __server_payload(params)
		"quad":
			return __quad_payload(params)
		"circle":
			return __circle_payload(params)
		"save_terrain":
			return __save_terrain_payload(params)
		"load_terrain":
			return __load_terrain_payload(params)
		"ls":
			return __list_files(params)
	return {"ERROR": "Invalid command"}

func __format_error(error: String):
	var base: Dictionary = {}
	base["ERROR"] = __error_message["ERROR"] % error
	return base

func __roll_payload(params: Array) -> Dictionary:
	var payload = {
		"emitter": "external",
		"type": "roll",
		"user": "DM",
		"content": params[1]
	}
	return payload

func __server_payload(params: Array):
	var payload = {
		"emitter": "external",
		"type": "server",
		"user": "DM",
		"content": params[1]
	}
	return payload

func __quad_payload(params: Array):
	if params.size() < 3:
		return __format_error("Required 2 (int) parameters WIDTH, HEIGHT")

	var payload = {
		"emitter": "internal",
		"type":  GhostBrush.BrushTypes.get(params[0].capitalize()),
		"width":  int(params[1]),
		"height": int(params[2]),
		"border": false
	}
	return payload

func __circle_payload(params: Array):
	if params.size() != 2:
		return __format_error("Required 1 (int) parameter DIAMETER")
	
	var payload = {
		"emitter": "internal",
		"type": GhostBrush.BrushTypes.get(params[0].capitalize()),
		"diameter": int(params[1]),
		"border": false
	}
	return payload

func __save_terrain_payload(params: Array):
	if params.size() != 2:
		return __format_error("Required 1 (int) parameter FILEPATH")
	
	var payload = {
		"emitter": "operation",
		"type": params[0],
		"filepath": params[1]
	}
	return payload
	
func __load_terrain_payload(params: Array):
	if params.size() != 2:
		return __format_error("Required 1 (int) parameter FILEPATH")
	
	var payload = {
		"emitter": "operation",
		"type": params[0],
		"filepath": params[1]
	}
	return payload

func __list_files(params: Array):
	var payload = {
		"emitter": "operation",
		"type": params[0],
		"path": params[1] if params.size() > 1 else ""
	}
	return payload
