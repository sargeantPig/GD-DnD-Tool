extends Tree

var grassy: Texture2D = load("res://tilemaps/tilemap_grassy.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(grassy.get_width()):
		for y in range(grassy.get_height()):
			create_item(root)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
