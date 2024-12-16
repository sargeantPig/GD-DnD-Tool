class_name ObjectContext extends Control


var connected_object: PlaceableObject
var connected_tree: ObjectTree
var details: Details

@export var display_name: LineEdit
@export var health: LineEdit
@export var max_health: LineEdit
@export var notes: TextEdit
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

# Called when the node enters the scene tree for the first time.
func _ready():
	details = Details.new()
	var required = [
		display_name, health, max_health, notes, 
		tabs, initiative, strength, dexterity, 
		constitution, intelligence, wisdom, charisma, 
		initiative_bonus, armour_class
	]
	Global.required_variables_set(required, self)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_details()
	if connected_object != null:
		connected_object.details.update_details(self.details)
		connected_tree.refresh(connected_object)
	pass

func refresh_details():
	details.display_name = display_name.text
	details.health = health.text
	details.max_health = max_health.text
	#details.notes = notes.text
	#details.status = status.text
	details.initiative = initiative.text
	details.str = strength.text
	details.dex = dexterity.text
	details.con = constitution.text
	details.intelligence = intelligence.text
	details.wis = wisdom.text
	details.cha = charisma.text
	details.initiative_bonus = initiative_bonus.text
	details.armour_class = armour_class.text
	#display_tabbed_text(details)

func recieve_object_details(_details: Details):
	self.details = _details
	display_name.text = _details.display_name
	health.text = _details.health
	#notes.text = details.notes
	#status.text = details.status
	max_health.text = _details.max_health
	initiative.text = _details.initiative
	strength.text = _details.str
	dexterity.text = _details.dex
	constitution.text = _details.con
	intelligence.text = _details.intelligence 
	wisdom.text = _details.wis  
	charisma.text = _details.cha
	initiative_bonus.text = _details.initiative_bonus
	armour_class.text = _details.armour_class
	display_tabbed_text(_details)
	pass

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
		self.details.initiative = calc
		self.initiative.text = calc
		connected_tree.refresh(connected_object)
	connected_tree.sort()
	pass # Replace with function body.


func _on_tab_container_tab_changed(tab):
	display_tabbed_text(details)
	pass # Replace with function body.
