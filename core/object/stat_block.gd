class_name StatBlock

var uid: String
var name: String
var data: Dictionary
var formatter: StatBlockFormatter

var extra_data: Dictionary = {
	"max_hp": 0,
	"initiative": 0,
}

var stat_indexes: Dictionary = {
	"strength": 0,
	"dexterity": 1,
	"constitution": 2,
	"intelligence": 3,
	"wisdom": 4,
	"charisma": 5
}

func _init(data: Dictionary) -> void:
	self.uid = UUID.v7()
	load_data(data)

func load_from_block(statblock: StatBlock):
	self.load_data(str_to_var(var_to_str(statblock.data)))
	return self

func load_data(data: Dictionary):
	if not data:
		return
	self.data = data
	formatter = StatBlockFormatter.new(self.data)
	self.name = self.data["name"]
	self.extra_data["max_hp"] = self.data["hp"]

func get_extra_data(key: String):
	if extra_data.has(key):
		return str(extra_data[key])
	return ""

func get_value(key: String):
	if data.has(key):
		return str(data[key])
	return ""

func set_extra_data(key: String, value: String):
	if extra_data.has(key):
		extra_data[key] = value

func set_value(key: String, value: String):
	if data.has(key):
		data[key] = value

func update_stats(stats: StatBlock):
	self.data = stats.data

func get_collection_string(key: String) -> String:
	if not formatter:
		return ""
	return formatter.get_collection_string(key)

func get_stat(key: String):
	if data.has("stats"):
		return str(data["stats"][stat_indexes[key]])
	return ""
