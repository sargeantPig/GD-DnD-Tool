class_name Server extends Node

var console: Console
var peer := WebSocketMultiplayerPeer.new()
var console_connected: bool = false

var serverCMD := ServerCMD.new()
var diceCMD := Dice.new()
var target: int

func _ready():
	peer.create_server(8080)
	get_tree().get_multiplayer(self.get_path())
	set_process(true)

func _process(delta):
	if !console_connected:
		console.send_message.connect(receive_message)
		console_connected = true
	
	peer.poll()
	#print(peer.get_available_packet_count())
	while peer.get_available_packet_count() > 0:
		var id = peer.get_packet_peer()
		var packet = peer.get_packet()
		var data = packet.get_string_from_utf8()
		handle_message(id, data)

func handle_message(peer_id, data):
	var response = "Success"
	var json = JSON.new()
	var err = json.parse(data)
	var payload = json.get_data()
	if "path" in payload:
		match payload["path"]:
			"api/v1/dice":
				response = "Roll received"
				console.receive_text(diceCMD.format_roll_response(payload))
	
	peer.set_target_peer(peer_id)
	target = peer_id
	#peer.put_packet(response.to_utf8_buffer())

func set_console(con: Console):
	self.console = con

func receive_message(cmd: Dictionary):
	process_cmd(cmd)

func process_cmd(cmd: Dictionary):
	match(cmd["type"]):
		"roll": diceCMD.roll_basic(cmd, self)
		"server": cmd_server(cmd)

func cmd_server(cmd):
	match(cmd["content"]):
		"status": console.receive_text(serverCMD.status(self))
