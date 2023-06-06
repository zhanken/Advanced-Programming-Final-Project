extends CharacterBody2D

var attached = false
var speed = .6
var offset = 5
var scored = false
var attachable = true
var tmloc: Vector2
signal ballchange(ballbool)
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")


func _physics_process(delta):
	var playerN = get_parent().get_node("Player")
	if position.distance_to(tmloc)<4:
		emit_signal("ballchange",false)
		print('stop bruh')
	if position.x > 270:
		position.x = 270
	if position.x < 51:
		position.x = 51
	if position.y > 349:
		position.y = 349
	if position.y < 66.9:
		position.y = 67
	if attached && scored == false:
		position = playerN.position + Vector2(offset,0)
		var dir = position - playerN.position
		var ang = rad_to_deg(dir.angle())
		if ang < -90 || ang > 90:
			position = playerN.position + Vector2(-5,0)
			offset = -5
		else:
			position = playerN.position + Vector2(5,0)
			offset = 5
	var distance = playerN.position.distance_to(position)
	if distance <= 6 && attachable:
		attached = true
		


func _on_player_passing():
	attached = false


func _on_player_shoot():
	attached = false
	attachable = false


func _on_node_2d_scored():
	scored = true


func _on_node_2d_tm_loc(loc):
	tmloc = loc

