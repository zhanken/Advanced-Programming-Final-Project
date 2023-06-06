extends CharacterBody2D
var go = false
var posspeed = .003
var speed = 2
var gameon = true
signal saved
func _physics_process(delta):
	var ball = get_parent().get_node("soccerball")
	var ballpos = ball.position
	var xtoball = ballpos.x - position.x
	var xmove = Vector2(xtoball,0)
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
