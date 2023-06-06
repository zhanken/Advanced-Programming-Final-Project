extends Node2D

var player: CharacterBody2D
var soccerBall: Node2D
var ballPhysics: PhysicsBody2D
var tm1: CharacterBody2D
var tm2: CharacterBody2D
var goalMID = Vector2(162,63)
var goalLEFT = Vector2(130,63)
var goalRIGHT = Vector2(192,63)
var attachedNow = false
var damping = .999
var currentVelocity: Vector2
var score = false
signal attached
signal scored
func _ready() -> void:
	player = get_node("Player")
	soccerBall = get_node("soccerball")
	ballPhysics = soccerBall.get_node("CollisionShape2D").get_node("RigidBody2D")

func _physics_process(delta: float) -> void:
	var distance = player.position.distance_to(soccerBall.position)
	currentVelocity *= damping
	if score == false:
		soccerBall.move_and_collide(currentVelocity * delta)
	if soccerBall.position.y < 67:
		if score == false:
			emit_signal("scored")
			score = true
	if distance < 6:
		attachedNow = true

func attachBall() -> void:
	emit_signal("attached")

func find_closest_teammate():
	var closest_teammate = null
	var closest_distance = INF# Set initial distance to a large value
	var teammates = [get_node("tm1"),get_node("tm2"),get_node("tm3"),get_node("tm4"),get_node("tm5")]
	for teammate in teammates:
		var playerpos = get_node("Player").position
		var tmpos = teammate.position
		var distance = get_node("Player").position.distance_to(teammate.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_teammate = teammate
	
	return closest_teammate
var passForce = 10
func _on_player_passing():
	soccerBall.set_deferred("collision_layer", 1)
	soccerBall.set_deferred("collision_mask", 1)
	var tmtopass = find_closest_teammate()
	if attachedNow:
		passForce = soccerBall.position.distance_to(tmtopass.position)*6
		var direction = (tmtopass.position - soccerBall.position).normalized()
		var velocity = direction * passForce
		var positionSave = tmtopass.position
		tmtopass.position = player.position
		player.position = positionSave
		currentVelocity = velocity
	attachedNow = false
		
var shootSpeed = 70
func _on_player_shoot():
	var dToGoal
	soccerBall.set_deferred("collision_layer", 1)
	soccerBall.set_deferred("collision_mask", 1)
	if attachedNow:
		if soccerBall.position.distance_to(goalLEFT) < soccerBall.position.distance_to(goalMID) && soccerBall.position.distance_to(goalLEFT) < soccerBall.position.distance_to(goalRIGHT):
			var direction = (goalLEFT - soccerBall.position).normalized()
			var velocity = direction * shootSpeed
			dToGoal = soccerBall.position.distance_to(goalLEFT)
			currentVelocity = velocity
		elif soccerBall.position.distance_to(goalMID) <= soccerBall.position.distance_to(goalLEFT) && soccerBall.position.distance_to(goalMID) <= soccerBall.position.distance_to(goalRIGHT):
			var direction = (goalMID - soccerBall.position).normalized()
			var velocity = direction * shootSpeed
			dToGoal = soccerBall.position.distance_to(goalMID)
			currentVelocity = velocity
		elif soccerBall.position.distance_to(goalRIGHT) <= soccerBall.position.distance_to(goalLEFT) && soccerBall.position.distance_to(goalRIGHT) <= soccerBall.position.distance_to(goalMID):
			var direction = (goalRIGHT - soccerBall.position).normalized()
			var velocity = direction * shootSpeed
			dToGoal = soccerBall.position.distance_to(goalRIGHT)
			currentVelocity = velocity
	print(dToGoal)
	attachedNow = false
