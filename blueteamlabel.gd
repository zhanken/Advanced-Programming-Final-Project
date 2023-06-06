extends Label

var teamname: String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_node_2d_scored():
	text = teamname + ": 1"



#func _on_teamname_text_submitted(new_text):
#	text = new_text + ": 0"
#	teamname = text


func _on_teamname_text_changed(new_text):
	text = new_text + ": 0"
	teamname = text
