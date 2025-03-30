extends SyntaxHighlighter

var text_edit: TextEdit

func set_text_edit(text_edit: TextEdit):
	self.text_edit = text_edit

func _get_line_syntax_highlighting(line) -> Dictionary:
	var line_content = text_edit.get_line(line)
	var highlights = {}
	var pattern = "(?<dice>\\b\\d+d\\d+(\\+\\d+)?|\\+\\d+|\\d+)|(?<title>^.+?:)"
	var regex = RegEx.new()
	var error = regex.compile(pattern)
	if error != OK:
		print("Regex compile error: ", error)
	
	var matches: Array[RegExMatch] = regex.search_all(line_content)
	var line_end = len(line_content)
	for m in matches:
		var start = m.get_start(0)
		var end = m.get_end(0)
		#print("Match found: ", m.get_string(0), " at positions: ", start, "-", end)
		var group_names = m.get_names()
		for group_name in group_names:
			var match_string = m.get_string(group_name)
			#print("Group: ", group_name, " Match: ", match_string)
			if group_name == "dice":
				highlights[start] = {"color": Color(0.957, 0.7, 0.7)}
			elif group_name == "title":
				highlights[start] = {"color": Color(0.7, 0.7, 0.957)}
			highlights[end] = {"color": Color(1, 1, 1)}

	return highlights
