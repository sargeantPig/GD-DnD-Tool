class_name Dice

func roll_basic(cmd: Dictionary, server: Server):
	var json_string = JSON.stringify(cmd)
	server.peer.put_packet(json_string.to_utf8_buffer())

func format_roll_response(body: Dictionary):
	var formatted = "\n%s\n\tRolled: %s: %s\n\tSummed: %s"
	return formatted % [body["user"], body["roll"], body["results"], body["sum"]]
