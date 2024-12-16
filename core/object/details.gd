class_name Details

var display_name: String
var internal_name: String
var notes: String
var status: String
var health: String
var max_health: String
var initiative: String = "10"
var str: String
var dex: String
var con: String
var intelligence: String
var wis: String
var cha: String
var armour_class: String
var initiative_bonus: String
var tab_group: Dictionary = {
	"actions": {},
	"abilities": {},
	"skills": {},
	"other": {}
}

func update(dis_name: String, int_name: String, notes: String, 
			status: String, health: String, max_health: String, 
			initiative: String, str: String, dex: String,
			con: String, intelligence: String, wis: String, cha: String,
			ac: String, initiative_bonus: String, actions: Dictionary,
			abilities: Dictionary, skills: Dictionary, other: Dictionary):
	self.display_name = dis_name
	self.internal_name = int_name
	self.notes = notes
	self.status = status
	self.health = health
	self.max_health = max_health
	self.initiative = initiative
	self.str = str
	self.dex = dex
	self.con = con
	self.intelligence = intelligence
	self.wis = wis
	self.cha = cha
	self.armour_class = ac
	self.initiative_bonus = initiative_bonus
	self.actions = actions
	self.abilities = abilities
	self.skills = skills
	self.other = other

func update_details(details: Details):
	self.display_name = details.display_name
	self.internal_name = details.internal_name
	self.notes = details.notes 
	self.status = details.status
	self.health = details.health
	self.max_health = details.max_health
	self.initiative = details.initiative
	self.str = details.str
	self.wis = details.wis
	self.dex = details.dex
	self.con = details.con
	self.intelligence = details.intelligence
	self.cha = details.cha
	self.armour_class = details.armour_class
	self.initiative_bonus = details.initiative_bonus
	tab_group["actions"] = details.tab_group["actions"]
	tab_group["abilities"] = details.tab_group["abilities"]
	tab_group["skills"] = details.tab_group["skills"]
	#self.actions = details.actions
	#self.skills = details.skills
	#self.other = details.other

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

func set_max_health(max_health: String):
	self.max_health = max_health

func set_initiative(initiative: String):
	self.initiative = initiative

func _save():
	var data = {
		"display_name": display_name,
		"internal_name": internal_name,
		"notes": notes,
		"status": status,
		"health": health,
		"max_health": max_health,
		"initiative": initiative,
		"strength": str,
		"dexterity": dex,
		"constitution": con,
		"intelligence": intelligence,
		"wisdom": wis,
		"charisma": cha,
		"armour_class": armour_class,
		"initiative_bonus": initiative_bonus,
	}
	return data

func load(data):
	display_name = data["display_name"]
	internal_name = data["internal_name"]
	notes = data["notes"]
	status = data["status"]
	health = data["health"]
	max_health = data["max_health"]
	if data.has("initiative"):
		initiative = data["initiative"]
	str = data["strength"]
	dex = data["dexterity"]
	con = data["constitution"]
	intelligence = data["intelligence"]
	wis = data["wisdom"]
	cha = data["charisma"]
	armour_class = data["armour_class"]
	initiative_bonus = data["initiative_bonus"]
	tab_group["actions"] = data["actions"]
	tab_group["abilities"] = data["abilities"]
	tab_group["skills"] = data["skills"]
	#tab_group["other"] = data["other"]
