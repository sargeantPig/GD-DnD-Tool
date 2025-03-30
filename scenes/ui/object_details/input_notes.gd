extends TextEdit


var text_edit = TextEdit.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var custom_syntax = preload("res://core/extensions/syntax_highlighter/custom_syntax.gd")
	syntax_highlighter = custom_syntax.new()
	syntax_highlighter.set_text_edit(self)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
