extends CharacterBody2D

# Variables
var target_position = Vector2.ZERO
var move_speed = 1
var min_distance = 10
var animation_player: AnimationPlayer
var speed = .06
var scored = false


func _physics_process(delta):
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
		elif scored == false:
			$AnimatedSprite2D.play("idle")



func _on_node_2d_scored():
	print('howdy there!')
	scored = true
	$AnimatedSprite2D.play("celebrate")
