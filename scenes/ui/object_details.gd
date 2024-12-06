class_name ObjectContext extends Control


var connected_object: PlaceableObject
var connected_tree: ObjectTree

var details: Details
# Called when the node enters the scene tree for the first time.
func _ready():
	details = Details.new()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_details()
	if connected_object != null:
		connected_object.details.update_details(self.details)
		connected_tree.refresh(connected_object)
	pass

func refresh_details():
	details.display_name = $ScrollContainer/GridContainer/GridContainer/base/lbl_name.text
	details.health = $ScrollContainer/GridContainer/GridContainer/base/input_health.text
	details.max_health = $ScrollContainer/GridContainer/GridContainer/base/input_health2.text
	details.notes = $ScrollContainer/GridContainer/GridContainer/extra/input_notes.text
	details.status = $ScrollContainer/GridContainer/GridContainer/extra/input_status.text
	details.initiative = $ScrollContainer/GridContainer/GridContainer/base/input_initiative.text
	details.str = $ScrollContainer/GridContainer/GridContainer2/input_str.text
	details.dex = $ScrollContainer/GridContainer/GridContainer2/input_dex.text
	details.con = $ScrollContainer/GridContainer/GridContainer2/input_con.text
	details.intelligence = $ScrollContainer/GridContainer/GridContainer2/input_int.text
	details.wis = $ScrollContainer/GridContainer/GridContainer2/input_wis.text
	details.cha = $ScrollContainer/GridContainer/GridContainer2/input_cha.text

func recieve_object_details(details: Details):
	self.details = details
	$ScrollContainer/GridContainer/GridContainer/base/lbl_name.text = details.display_name
	$ScrollContainer/GridContainer/GridContainer/base/input_health.text = details.health
	$ScrollContainer/GridContainer/GridContainer/extra/input_notes.text = details.notes
	$ScrollContainer/GridContainer/GridContainer/extra/input_status.text = details.status
	$ScrollContainer/GridContainer/GridContainer/base/input_health2.text = details.max_health
	$ScrollContainer/GridContainer/GridContainer/base/input_initiative.text = details.initiative
	$ScrollContainer/GridContainer/GridContainer2/input_str.text = details.str
	$ScrollContainer/GridContainer/GridContainer2/input_dex.text = details.dex
	$ScrollContainer/GridContainer/GridContainer2/input_con.text = details.con
	$ScrollContainer/GridContainer/GridContainer2/input_int.text = details.intelligence 
	$ScrollContainer/GridContainer/GridContainer2/input_wis.text = details.wis  
	$ScrollContainer/GridContainer/GridContainer2/input_cha.text = details.cha
	pass


func _on_input_initiative_text_changed(new_text):
	if connected_object != null:
		self.details.initiative = new_text
		connected_tree.refresh(connected_object)
	connected_tree.sort()
	pass # Replace with function body.
