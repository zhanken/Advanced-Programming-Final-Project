extends CharacterBody2D

signal shoot
signal passing
signal location

var speed = .6
var lastdir: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")


func _physics_process(delta):
	if true:
		var dir = Vector2.ZERO
		if Input.is_action_pressed("up"):
			dir.y = -1
		if Input.is_action_pressed("down"):
			dir.y = 1	
		if Input.is_action_pressed("left"):
			dir.x = -1	
		if Input.is_action_pressed("right"):
			dir.x = 1
		dir = dir.normalized()
		move_and_collide(dir * speed)
	
	
		if dir.length() > 0:
			if dir.x > 0:
				$AnimatedSprite2D.play("run_right")
				$AnimatedSprite2D.flip_h = false
			elif dir.x < 0:
				$AnimatedSprite2D.play("run_right")
				$AnimatedSprite2D.flip_h = true
			elif dir.y > 0:
				$AnimatedSprite2D.play("run_down")
				$AnimatedSprite2D.flip_h = false
			elif dir.y < 0:
				$AnimatedSprite2D.play("run_up")
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle")
		
		if Input.is_action_pressed("pass"):
			emit_signal("passing")
		if Input.is_action_pressed("shoot"):
			emit_signal("shoot")
		
		lastdir = dir


	

