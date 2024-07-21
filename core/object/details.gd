class_name Details

var display_name: String
var internal_name: String
var notes: String
var status: String
var health: String

func update(dis_name: String, int_name: String, notes: String, status: String, health: String):
	self.display_name = dis_name
	self.internal_name = int_name
	self.notes = notes
	self.status = status
	self.health = health

func set_display_name(name: String):
	self.display_name = name

func set_internal_name(name: String):
	self.internal_name = name

func set_notes(notes: String):
	self.notes = notes

func set_status(status: String):
	self.status = status

func set_health(health: String):
	self.health = health

func _save():
	var data = {
		"display_name": display_name,
		"internal_name": internal_name,
		"notes": notes,
		"status": status,
		"health": health
	}
	return data

func load(data):
	display_name = data["display_name"]
	internal_name = data["internal_name"]
	notes = data["notes"]
	status = data["status"]
	health = data["health"]
