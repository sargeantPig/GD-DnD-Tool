extends Node

func simple_calc(new_text):
	var sum: String = new_text
	if "+" in new_text:
		var split = new_text.split('+')
		sum = str(int(split[0]) + int(split[1]))
	if "-" in new_text:
		var split = new_text.split('-')
		sum = str(int(split[0]) - int(split[1]))
	if "/" in new_text:
		var split = new_text.split('/')
		sum = str(int(split[0]) / int(split[1]))
	if "*" in new_text:
		var split = new_text.split('*')
		sum = str(int(split[0]) * int(split[1]))
	return sum
