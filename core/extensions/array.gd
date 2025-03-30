class_name ExArray

var array: Array = []

func _init(array) -> void:
	self.array = Array(array) 

func join(delim: String) -> String:
	var new_string: String = ""
	for item in array:
		new_string += item + "\n"
	return new_string
