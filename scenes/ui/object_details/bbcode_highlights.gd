class_name BBCodeHighlights

var patterns: Dictionary
var titlesymbols: Dictionary

func _init(patterns: Dictionary, titlesymbols: Dictionary) -> void:
	self.patterns = patterns
	self.titlesymbols = titlesymbols

func apply_highlights(text: String):
	var lines = text.split("\n")
	var highlighted: Array = []
	## first check for symbols
	for line in lines:
		for symbol in titlesymbols:
			var end = line.find(symbol)
			if end != -1:
				var before = line.substr(0, end)
				var after = line.substr(end)
				highlighted.append("%s%s[/color]%s" % [titlesymbols[symbol], before, after])
			else:
				highlighted.append(line)
	
	var titles_highlighted: String = "\n".join(highlighted)
	
	var reg = RegEx.new()
	
	for pattern in self.patterns:
		reg.compile(pattern)
		var matches: Array[RegExMatch] = reg.search_all(titles_highlighted)
		matches.reverse()
		for m in matches:
			var start = m.get_start()
			var end = m.get_end()
			var before = titles_highlighted.substr(0, start)
			var after = titles_highlighted.substr(end)
			var found = m.get_string()
			titles_highlighted = "%s%s%s[/color]%s" % [before, patterns[pattern], m.get_string(), after]
		

	return titles_highlighted
