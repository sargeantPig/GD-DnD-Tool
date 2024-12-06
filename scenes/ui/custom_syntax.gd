extends SyntaxHighlighter

var text_edit: TextEdit

func set_text_edit(text_edit: TextEdit):
	self.text_edit = text_edit

func _get_line_syntax_highlighting(line) -> Dictionary:
	var line_content = text_edit.get_line(line)
	var highlights = {}
	var pattern = "\\b\\d+d\\d+(\\+\\d+)?|\\+\\d|\\d"  # Properly escaped pattern
	var regex = RegEx.new()
	regex.compile(pattern)
	
	var matches: Array[RegExMatch] = regex.search_all(line_content)
	var line_end = len(line_content)
	for m in matches:
		var start =  m.get_start(0)
		var end = m.get_end(0)
		highlights[start] = {"color": Color(0.957, 0.7, 0.7)}
		highlights[end] = {"color": Color(1, 1, 1)}

	return highlights

