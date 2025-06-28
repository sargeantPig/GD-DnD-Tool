class_name StatBlockFormatter

var data: Dictionary

func _init(data: Dictionary) -> void:
	self.data = data

func get_collection_string(key: String):
	var text = ""
	var method = "%s_collection_string" % key
	
	if not self.has_method(method):
		return text
	text += self.call(method, key)
	return text

func abilities_collection_string(_key: String) -> String:
	var text = ""
	if data.has("speed"):
		text += "Speed; %s\n" % data["speed"]
	if data.has("languages"):
		text += "Languages; %s\n" % data["languages"]
	if data.has("senses"):
		text += "Senses; %s\n" % data["senses"]
	if data.has("damage_vulnerabilities"):
		text += "Damage Vulnerabilities; %s\n" % data["damage_vulnerabilities"]
	if data.has("damage_resistances"):
		text += "Damage Resistances; %s\n" % data["damage_resistances"]
	if data.has("damage_immunities"):
		text += "Damage Immunities; %s\n" % data["damage_immunities"]
	if data.has("condition_immunities"):
		text += "Condition Immunities; %s\n" % data["condition_immunities"]
	return text

func traits_collection_string(key: String) -> String:
	var text = ""
	if data.has(key):
		for _trait in data[key]:
			text += _action_string(_trait)
	return text

func other_collection_string(_key: String) -> String:
	var text = ""
	var xptable: CRXP = CRXP.new()
	if data.has("cr"):
		text += "CR; %s - %sxp\n" % [data["cr"], xptable.get_xp_by_cr(data["cr"])]
	if data.has("alignment"):
		text += "Alignment; %s\n" % data["alignment"]
	if data.has("languages"):
		text += "Languages; %s\n" % data["languages"]
	if data.has("senses"):
		text += "Senses; %s\n" % data["senses"]
	if data.has("size"):
		text += "Size; %s\n" % data["size"]
	if data.has("type"):
		text += "Type; %s\n" % data["type"]
	if data.has("subtype"):
		text += "Subtype; %s\n" % data["subtype"]
	return text

func saves_collection_string(key: String) -> String:
	var text = ""
	if data.has(key):
		for save in data[key]:
			text += ability_save_string(save)
	if data.has("skillsaves"):
		for save in data["skillsaves"]:
			text += ability_save_string(save)
	return text

func ability_save_string(save: Dictionary):
	var text = ""
	for item in save.keys():
		text += "%s; %s\n" % [item, save[item]]
	return text

func actions_collection_string(key: String) -> String:
	var text = ""
	if data.has(key):
		for action in data[key]:
			text += _action_string(action)
	if data.has("reactions"):
		text += _reactions_action_string()
	if data.has("spells"):
		text += _spells_string()
	if data.has("legendary_actions"):
		text += _legendary_action_string()
	return text

func _spells_string():
	var text = "Spells;\n"
	if data["spells"] == null:
		return ""
	for spells in data["spells"]:
		if spells is String:	
			text += "%s\n" % spells.replace(":", "") 
		elif spells is Dictionary:
			for lvl in spells:
				text += "%s;\n" % lvl
				text += get_spell_urls(lvl, spells)
	return text

func get_spell_urls(level: String, spell: Dictionary):
	var text = ""
	var spells = spell[level].split(",", false)
	for s: String in spells:
		var url = "https://dnd5e.wikidot.com/spell:%s" % s.lstrip(" ")
		text += "\t%s\n" % url_display(url)
	return text

func _reactions_action_string() -> String:
	var text = "Reactions;\n"
	for reaction in data["reactions"]:
		text += _action_string(reaction)
	return text

func _legendary_action_string() -> String:
	var text = "Legendary Actions;\n"
	for legendary_action in data["legendary_actions"]:
		text += _action_string(legendary_action)
	return text

func _action_string(action: Dictionary):
	var text = ""
	text += "%s;\n" % action["name"]
	text += "%s\n" % action["desc"]
	return text

func url_display(url: String):
	var split = url.split(":")
	return "[url=%s][color='lightblue']%s[/color][/url]" % [url,  split[-1]]
