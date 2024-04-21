extends RichTextLabel


@export var selected_terrain_index: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var watched: Dictionary = {
		"selected terrain index": 0
	}
	
	var temptext: String
	
	for item in watched:
		var format = item + " %s\n"
		temptext += format % watched[item]
	text = temptext
	pass
