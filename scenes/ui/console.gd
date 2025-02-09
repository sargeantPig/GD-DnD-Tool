class_name Console extends Panel 

signal send_message(msg)
signal internal_message(msg)

@export var last_child: Control
@export var output: RichTextLabel
@export var input: LineEdit

var input_format = "\n\n> %s"
var output_format = "\n%s"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	custom_minimum_size = Vector2(last_child.position.x + last_child.size.x, last_child.position.y + last_child.size.y)
	pass

func receive_text(text: String):
	output.append_text(output_format % [text])

func _on_line_edit_text_submitted(new_text):
	output.append_text(input_format % [new_text])
	command_execute(new_text)
	input.clear()
	pass # Replace with function body.

func command_execute(cmd: String):
	if cmd.begins_with("roll"):
		var payload = {
			"type": "roll",
			"user": "DM",
			"content": cmd.split(" ")[1]
		}
		send_message.emit(payload)
	elif cmd.begins_with("server"):
		var payload = {
			"type": "server",
			"user": "DM",
			"content": cmd.split(" ")[1]
		}
		send_message.emit(payload)
	elif cmd.begins_with("quad_brush"):
		var params = cmd.split(" ")
		
		if params.size() < 3:
			self.receive_text("Error: Incorrect params provided")
			return

		var payload = {
			"type": params[0],
			"width": params[1],
			"height": params[2]
		}

		internal_message.emit(payload)
		
