extends CanvasLayer
signal winshootout(tmG,enG)
signal loseshootout(tmG,enG)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_node_2d_penswin():
	visible = true


func _on_button_pressed():
	var teammatesGoals = randi_range(0,4)
	var enemyGoals = randi_range(0,5)
	if teammatesGoals in [0,1]:
		teammatesGoals = randi_range(0,4)
	if enemyGoals in [0,1,2]:
		enemyGoals = randi_range(0,5)
	teammatesGoals += 1
	if teammatesGoals == enemyGoals:
		teammatesGoals+=1
	if teammatesGoals > enemyGoals:
		emit_signal("winshootout",teammatesGoals,enemyGoals)
	else:
		emit_signal("loseshootout",teammatesGoals,enemyGoals)
