class_name Console extends Panel 

signal send_message(msg)
signal internal_message(msg)
signal operation_message(msg)

@export var last_child: Control
@export var output: RichTextLabel
@export var input: LineEdit

@export var load_func: LoadTree

var input_format = "\n\n> %s"
var output_format = "\n%s"

var commands: ConsoleCommands
# Called when the node enters the scene tree for the first time.
func _ready():
	commands = ConsoleCommands.new()
	load_func.file_selected.connect(_on_load_file)
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
	var payload = commands.process_command(cmd)
	
	if payload.has("ERROR"):
		self.receive_text(payload["ERROR"])
		return
	
	match payload["emitter"]:
		"internal": internal_message.emit(payload)
		"external": send_message.emit(payload)
		"operation": operation_message.emit(payload)

func _on_load_file(filename: String) -> void:
	_on_line_edit_text_submitted("load_terrain %s" % filename)

func _on_save_file_submitted(filename: String) -> void:
	_on_line_edit_text_submitted("save_terrain %s" % filename)
	load_func.load_saves()
	pass # Replace with function body.
