extends Control

signal btn_clicked(id: String)

@export var tile_size: float

@export var default_tex: Texture2D
@export var clicked_tex: Texture2D
@export var hovered_tex: Texture2D
@export var has_multiple_atlas: bool
@export_enum("top", "left", "right", "bottom") var anchor = 0
@export var tile_names: Array[String]
@export var name_format: String
@export var padding: int
@export var backdrop: Panel 

var btn_count: int = 0
var screen_center: float = 0
var toolbar_width_halved: float = 0
var names_not_unique: bool = false
var buttons: Array[TextureButton] = []
var current_pressed: String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	var sheet_width = default_tex.get_width()
	var sheet_height = default_tex.get_height()
	var name_count: int = tile_names.size()
	
	scale = Vector2(2, 2)
	screen_center = get_viewport().get_visible_rect().size.x / 2
	
	var i: int = 0
	var x_range: int = sheet_width/tile_size
	var y_range: int = sheet_height/tile_size
	if name_count == 0:
		tile_names.append("-")
		name_count = tile_names.size()
	if name_count <= 1:
		names_not_unique = true

	var name_ind: int = 0
	var counter: int = 0
	for y in range(y_range):
		for x in range(x_range):
			if !names_not_unique && counter >= name_count:
				continue
			var button = create_button(tile_names[name_ind], counter)
			set_new_atlas(button, x*tile_size, y*tile_size, tile_size)
			add_child(button)
			name_ind +=1
			counter+=1
			print(counter)
			buttons.append(button)
			name_ind = clampi(name_ind, 0, name_count-1)
			
	btn_count = buttons.size()
	var scaled = tile_size*scale.x
	var real_width = btn_count*scaled
	toolbar_width_halved = real_width/2
	print(toolbar_width_halved)
	pass # Replace with function body.

func handle_name(name: String, index: int):
	if(names_not_unique):
		return name_format % [index]
	else: return name

func create_button(name: String, index: int) -> TextureButton:
	var processed_name = handle_name(name, index)
	var newButton: TextureButton = TextureButton.new()
	newButton.toggle_mode = true
	newButton.name = processed_name
	newButton.tooltip_text = processed_name.split("_")[2]
	return newButton

func set_new_atlas(btn: TextureButton, x: int, y: int, s: int):
	btn.texture_normal = AtlasTexture.new()
	btn.texture_normal.atlas = default_tex
	btn.texture_normal.region = Rect2(x, y, s, s)
	btn.texture_pressed = AtlasTexture.new()
	btn.texture_pressed.atlas = clicked_tex
	btn.texture_pressed.region = Rect2(x, y, s, s)
	btn.texture_hover = AtlasTexture.new()
	btn.texture_hover.atlas = hovered_tex
	btn.texture_hover.region = Rect2(x, y, s, s)
	btn.pressed.connect(button_pressed.bind(btn.name))
	
	if !has_multiple_atlas:
		btn.texture_normal.atlas = default_tex
		btn.texture_pressed.atlas = default_tex
		btn.texture_hover.atlas = default_tex

func _process(delta):
	if anchor == 0:
		screen_center = get_viewport().get_visible_rect().size.x / 2
		var x: float = screen_center - toolbar_width_halved
		position = Vector2(x+padding, 0)
	elif anchor == 1:
		position = Vector2(0+padding, 0+padding)
	elif anchor == 2:
		var x: int = get_viewport().get_visible_rect().size.x - (tile_size*scale.x)
		position = Vector2(x-padding, 0-padding)
	elif anchor == 3:
		screen_center = get_viewport().get_visible_rect().size.x / 2
		var x: int = screen_center - toolbar_width_halved
		var y: int = get_viewport().get_visible_rect().size.y - (tile_size*scale.x)
		position = Vector2(x, y)
		
	if backdrop != null:
		backdrop.size = (size * scale.x) + Vector2(padding*2, padding*2)
		backdrop.position = position
	pass

func button_pressed(id):
	if id == current_pressed:
		return
	for btn in buttons:
		if btn.name == id:
			if !has_multiple_atlas:
				btn.modulate = Color(1, 0.5, 0.5)
			continue
		btn.button_pressed = false
		if !has_multiple_atlas:
				btn.modulate = Color(1, 1, 1)
	current_pressed = id
	btn_clicked.emit(id)
	pass
