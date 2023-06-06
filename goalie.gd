extends CharacterBody2D
var go = false
var posspeed = .006
var speed = 2.2
var gameon = true
signal saved
func _physics_process(delta):
	if position.y != 68:
		position.y = 68
	var ball = get_parent().get_node("soccerball")
	var ballpos = ball.position
	var xtoball = ballpos.x - position.x
	var xmove = Vector2(xtoball,0)
	if gameon:
		move_and_collide(xmove*posspeed)
	if go:
		var direction = (ballpos - position).normalized()
		move_and_collide(direction*speed)
	if position.distance_to(ballpos) < 5 && gameon:
		emit_signal("saved")
		get_parent().get_node("soccerball").position = Vector2(171,161)
		print("saved")
		go = false


func _on_node_2d_shooting():
	go = true


func _on_node_2d_scored():
	gameon = false
	go = false


func _on_player_penshot():
	gameon = true
	go = true


func _on_node_2d_waitscore():
	go = false
	gameon = false
