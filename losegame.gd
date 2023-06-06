extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_node_2d_lost_1():
	visible = true


func _on_button_pressed():
	visible = false
