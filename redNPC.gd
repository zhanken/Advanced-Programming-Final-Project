extends CharacterBody2D

# Variables
var target_position = Vector2.ZERO
var min_distance = 10
var animation_player: AnimationPlayer
var speed = .06
var toballspeed = .3
var gameStarted = false
signal lose_game
func _ready():
	animation_player = $AnimationPlayer

func _physics_process(delta):
	if gameStarted:
		var soccerball = get_parent().get_node("soccerball")
		var ballloc = soccerball.position
		var direction = (ballloc - position).normalized()
		if position.distance_to(ballloc) < 40:
			move_and_collide(direction*toballspeed)
		if position.distance_to(ballloc) < 4:
			emit_signal("lose_game")
			gameStarted = false
		if true:
			var dir = Vector2.ZERO
			if Input.is_action_pressed("up"):
				dir.y = -1
			if Input.is_action_pressed("down"):
				dir.y = 1
			dir = dir.normalized()
			move_and_collide(dir * speed)
	
	
			if dir.length() > 0:
				if dir.y > 0:
					$AnimatedSprite2D.play("run_down")
					$AnimatedSprite2D.flip_h = false
				elif dir.y < 0:
					$AnimatedSprite2D.play("run_up")
					$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.play("idle")



func _on_startgame_pressed():
	gameStarted = true


func _on_node_2d_scored():
	gameStarted = false


func _on_goalie_saved():
	gameStarted = false
