class_name HotkeyHints extends RichTextLabel

var panel: Panel

var hint_cache: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel = get_parent()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("shift"):
		_display_possibilities("Shift")
	elif Input.is_action_pressed("control"):
		_display_possibilities("Ctrl")
	else: 
		text = ""
		panel.visible = false
	pass

func _display_possibilities(filter: String):
	var all_text: String
	panel.visible = true
	
	if hint_cache.has(filter):
		text = hint_cache[filter]
		return
	
	hint_cache[filter] = ""
	for input in InputMap.get_actions():
		var ie: Array[InputEvent] = InputMap.action_get_events(input)
		for e in ie:
			var keys = e.as_text()
			if keys.contains(filter) and not input.contains("ui_"):
				var hint = "[color=#3a9fbf]%s: %s[/color]\n" % [input, e.as_text().replace("(Physical)", "")]
				hint_cache[filter] += hint
				all_text += hint
	text = all_text
