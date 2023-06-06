extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	visible = true


func _on_node_2d_lost_1():
	visible = false
