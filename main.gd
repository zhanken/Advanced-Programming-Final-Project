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
var damping = .9
var currentVelocity: Vector2
var teammates = [get_node("tm1"), get_node("tm2"), get_node("tm3"), get_node("tm4"), get_node("tm5")]
signal attached
func _ready() -> void:
	player = get_node("Player")
	soccerBall = get_node("soccerball")
	ballPhysics = soccerBall.get_node("CollisionShape2D").get_node("RigidBody2D")

func _physics_process(delta: float) -> void:
	var distance = player.position.distance_to(soccerBall.position)
	currentVelocity *= damping
	soccerBall.move_and_collide(currentVelocity * delta)
	if soccerBall.position.y < 67:
		print('GOALL')
	if distance < 6:
		attachedNow = true

func attachBall() -> void:
	soccerBall.set_deferred("collision_layer", 0)
	soccerBall.set_deferred("collision_mask", 0)
	emit_signal("attached")

func find_closest_teammate():
	var closest_teammate = null
	var closest_distance = INF # Set initial distance to a large value
	
	for teammate in teammates:
		var distance = get_node("Player").position.distance_to(teammate.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_teammate = teammate
	
	return closest_teammate
var passForce = 100
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
		
var shootSpeed = 700
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
