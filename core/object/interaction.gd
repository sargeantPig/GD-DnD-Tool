class_name Interaction

signal mouse_entered_rect()
signal mouse_left_rect()
signal selected_toggled(is_selected)
signal is_selected()
signal log_event(msg)


var rect: Rect2
var mouse_hover: bool = false
var selected: bool = false
var is_dragging: bool = false

func _init(rect: Rect2):
	self.rect = rect

func update(mousePos: Vector2, position: Vector2):
	check_mouse_in_rect(mousePos)

func check_input(event: InputEvent):
	var select_clicked = event.is_action_released("select") 
	if select_clicked && mouse_hover:
		select()

func toggle_mouse_hover():
	self.mouse_hover = !mouse_hover

func toggle_selected():
	self.selected = !selected
	selected_toggled.emit(selected)
	log_event.emit(" selected", selected)

func select():
	self.selected = true
	is_selected.emit()
	log_event.emit(" selected", selected)

func set_mouse_hover(value: bool):
	self.mouse_hover = value

func check_mouse_in_rect(mousePos: Vector2):
	var mouseRect: Rect2 = Rect2(mousePos, Vector2.ONE)
	if rect.abs().encloses(mouseRect):
		if !mouse_hover:
			set_mouse_hover(true)
			mouse_entered_rect.emit()
			log_event.emit(" mouse entered rect")
	else:
		if mouse_hover:
			set_mouse_hover(false)
			mouse_left_rect.emit()
			log_event.emit(" mouse left rect")
			
