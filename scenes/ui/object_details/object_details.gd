class_name ObjectContext extends Control


var connected_object: PlaceableObject
var connected_tree: ObjectTree
var statblock: StatBlock
var highlighter: BBCodeHighlights

@export var display_name: LineEdit
@export var health: LineEdit
@export var max_health: LineEdit
@export var notes: RichTextLabel
@export var tabs: TabContainer
@export var initiative: LineEdit
@export var strength: RichTextLabel
@export var dexterity: RichTextLabel
@export var constitution: RichTextLabel
@export var intelligence: RichTextLabel
@export var wisdom: RichTextLabel
@export var charisma: RichTextLabel
@export var initiative_bonus: LineEdit
@export var armour_class: LineEdit
@export var url: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	highlighter = BBCodeHighlights.new(
	{
		"(?!#\\S*)\\b\\d+d\\d+(\\+\\d+)?|\\+\\d+|\\b\\d+\\b": "[color=#F3B2B2]"
	}, 
	{
		";": "[color=#B2B2F3]"
	})
	
	var required = [
		display_name, health, max_health, notes, 
		tabs, initiative, strength, dexterity, 
		constitution, intelligence, wisdom, charisma, 
		initiative_bonus, armour_class
	]
	Global.required_variables_set(required, self)
	statblock = StatBlock.new({})
	

func _process(_delta):
	refresh_stats()
	if connected_object != null:
		connected_object.statblock.update_stats(self.statblock)
		connected_tree.refresh(connected_object)
	pass

func refresh_stats():
	statblock.set_value("name", display_name.text)
	statblock.set_value("hp", health.text)
	statblock.set_value("ac", armour_class.text)
	statblock.set_value("max_hp", max_health.text)
	statblock.set_extra_data("initiative", initiative.text)
	statblock.set_value(armour_class.text, "ac")

func set_stats(stats: StatBlock):
	if not stats:
		return
	self.statblock = stats
	display_name.text = stats.get_value("name")
	health.text = stats.get_value("hp")
	max_health.text = stats.get_extra_data("max_hp")
	initiative.text = stats.get_extra_data("initiative")
	strength.text = stats.get_stat("strength")
	dexterity.text = stats.get_stat("dexterity")
	constitution.text = stats.get_stat("constitution")
	intelligence.text = stats.get_stat("intelligence")
	wisdom.text = stats.get_stat("wisdom")
	charisma.text = stats.get_stat("charisma")
	initiative_bonus.text = ""
	armour_class.text = stats.get_value("ac")
	url.text = url_display("https://roll20.net/compendium/dnd5e/%s" % stats["name"])
	new_display_tabbed_text(stats)

func url_display(url: String):
	var split = url.split("/")
	return "Source: [url=%s][color='lightblue']%s[/color][/url]" % [url,  split[-1]]

func new_display_tabbed_text(stats: StatBlock):
	var current_tab = tabs.get_tab_title(tabs.current_tab).to_lower()
	var text: String = ""
	notes.text = highlighter.apply_highlights(stats.get_collection_string(current_tab)).replace(";", ":")

func display_tabbed_text(_details: Details):
	var current_tab = tabs.get_tab_title(tabs.current_tab).to_lower()
	var text: String = ""
	for key in _details.tab_group[current_tab]:
		text += key.capitalize() + ": " + _details.tab_group[current_tab][key] + "\n" 
	notes.text = text

func _on_input_health_text_submitted(new_text):
	var sum: String = SimpleCalculator.simple_calc(new_text)
	self.health.text = sum

func _on_input_initiative_text_submitted(new_text):
	var combine = new_text + initiative_bonus.text
	var calc = SimpleCalculator.simple_calc(combine)
	if connected_object != null:
		self.statblock.set_extra_data("initiative", calc)
		self.initiative.text = calc
		connected_tree.refresh(connected_object)
	connected_tree.sort()
	pass # Replace with function body.

func _on_tab_container_tab_changed(_tab):
	new_display_tabbed_text(statblock)
	pass # Replace with function body.

func _on_url_meta_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.
