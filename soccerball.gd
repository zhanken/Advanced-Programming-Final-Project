extends CharacterBody2D

var attached = false
var speed = .6
var offset = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")


func _physics_process(delta):
	var playerN = get_parent().get_node("Player")
	if attached:
		position = playerN.position + Vector2(offset,0)
	var distance = playerN.position.distance_to(position)
	if distance < 6:
		var dir = position - playerN.position
		var ang = rad_to_deg(dir.angle())
		if ang < -90 || ang > 90:
			position = playerN.position + Vector2(-5,0)
			offset = -5
		else:
			position = playerN.position + Vector2(5,0)
			offset = 5
		


func _on_node_2d_attached():
	attached = true


func _on_player_passing():
	attached = false


func _on_player_shoot():
	attached = false
