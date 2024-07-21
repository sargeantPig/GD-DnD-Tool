extends Node

enum Mode {
	eposition,
	erotation,
	escale,
	eselect,
	emulti,
	ecancel,
	epaint,
	eerase,
	ebucket,
	epicker,
	esave,
	eload,
	eflip,
	ecolour,
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func check_mouse_in_rect(mousePos: Vector2, rect: Rect2 ):
	var mouseRect: Rect2 = Rect2(mousePos, Vector2.ONE)
	return rect.abs().encloses(mouseRect)
	
