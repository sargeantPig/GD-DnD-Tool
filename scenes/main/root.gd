extends Node2D

# area of effect cones, etc
# move characters
# spell ranges/ movement
# data structure for character sheets ------ longer term goal
# forestry, stone, wooden textures
# icons for effects like fire, ice, toxic, bleeding small 16x16 or 8x8

# networking in future ---- longer term

var selectedIndex: int = 0
var tilesets: Array = [$grassy_terrain, $objects]
var mode: Global.Mode
var palettte_index: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$ui.palette_index_changed.connect(palette_index_changed)
	$ui.mode_changed.connect(mode_changed)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mode = $ui.mode
	if mode == Global.Mode.epaint:
		paint()
	pass

func paint():
	pass

func _input(event):
	if event.is_action_pressed("tilemap_cycle_right"):
		modify_selected_index(1)
	elif event.is_action_pressed("tilemap_cycle_left"):
		modify_selected_index(-1)
	pass
	
	
func add_tile():
	
	pass

func remove_tile():
	pass

func palette_index_changed(value: int):
	palettte_index = value
	print(str(value) + " recieved")

func mode_changed(value: Global.Mode):
	mode = value

func modify_selected_index(value: int):
	selectedIndex = clampi(selectedIndex + value,  0, tilesets.size()-1)
	pass
