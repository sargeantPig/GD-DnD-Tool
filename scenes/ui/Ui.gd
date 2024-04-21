extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for file in DirAccess.open("res://weapon_icons").get_files():
		if !file.contains(".import"):
			
			print(file)
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
