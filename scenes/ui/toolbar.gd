extends Control

signal btn_clicked(id: String)



@export var default_tex: Texture2D
@export var clicked_tex: Texture2D
@export var hovered_tex: Texture2D
@export var has_multiple_atlas: bool
@export_enum("top", "left", "right", "bottom") var anchor = 0

var btn_count: int = 0
var screen_center: int = 0
var toolbar_width_halved: int = 0
var buttons: Array[TextureButton] = []
var current_pressed: String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		buttons.append(child)
	scale = Vector2(2, 2)
	screen_center = get_viewport().get_visible_rect().size.x / 2
	btn_count = buttons.size()
	toolbar_width_halved = (btn_count*(32*scale.x))/2
	var i: int = 0
	var x: int = 0
	var y: int = 0
	var s: int = 32
	for btn in buttons:
		if i >= buttons.size()/2:
			i = 0
			y += 32
		x = i * 32
		set_new_atlas(btn, x, y, s)
		i += 1
	pass # Replace with function body.


func create_button() -> TextureButton:
	var newButton: TextureButton = TextureButton.new()
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
		var x: int = screen_center - toolbar_width_halved
		position = Vector2(x, 0)
	elif anchor == 1:
		position = Vector2(0, 0)
	elif anchor == 2:
		var x: int = get_viewport().get_visible_rect().size.x - (32*scale.x)
		position = Vector2(x, 0)
	elif anchor == 3:
		screen_center = get_viewport().get_visible_rect().size.x / 2
		var x: int = screen_center - toolbar_width_halved
		var y: int = get_viewport().get_visible_rect().size.y - (32*scale.x)
		position = Vector2(x, y)
	pass

func button_pressed(id):
	if id == current_pressed:
		return
	for btn in buttons:
		if btn.name == id:
			if !has_multiple_atlas:
				btn.modulate = Color(1, 1, 0.5)
			continue
		btn.button_pressed = false
		if !has_multiple_atlas:
				btn.modulate = Color(1, 1, 1)
	current_pressed = id
	btn_clicked.emit(id)
	pass
