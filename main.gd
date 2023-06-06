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
var damping = .99
var currentVelocity: Vector2
var score = false
var timerValue = 15
var gameStarted = false
signal lost1
signal attached
signal scored
signal tmLoc(loc)
func _ready() -> void:
	player = get_node("Player")
	soccerBall = get_node("soccerball")

func _physics_process(delta: float) -> void:
	if gameStarted:
		timerValue -= delta
		if timerValue <= 0:
			emit_signal("lost1")
			gameStarted = false
			timerValue = 15
		var fmtTimer = str(timerValue).pad_decimals(2)
		get_node("scoreboard/timer").text = str(fmtTimer)
	var distance = player.position.distance_to(soccerBall.position)
	currentVelocity *= damping
	if score == false:
		soccerBall.move_and_collide(currentVelocity * delta)
	if soccerBall.position.y < 67 && soccerBall.position.x >129 && soccerBall.position.x < 193:
		if score == false:
			emit_signal("scored")
			gameStarted = false
			score = true
	if distance < 6:
		attachedNow = true

func attachBall() -> void:
	emit_signal("attached")

func find_closest_teammate():
	var closest_teammate = null
	var closest_distance = INF
	var teammates = [get_node("tm1"),get_node("tm2"),get_node("tm3"),get_node("tm4"),get_node("tm5")]
	for teammate in teammates:
		var playerpos = get_node("Player").position
		var tmpos = teammate.position
		var distance = get_node("Player").position.distance_to(teammate.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_teammate = teammate
	return closest_teammate
var passForce = 90
func _on_player_passing():
	damping = .98
	var tmtopass = find_closest_teammate()
	if attachedNow:
		var direction = (tmtopass.position - soccerBall.position).normalized()
		var velocity = direction * passForce
		var positionSave = tmtopass.position
		tmtopass.position = player.position
		player.position = positionSave
		currentVelocity = velocity
	attachedNow = false
	emit_signal("tmLoc",tmtopass.position)
var shootSpeed = 200
func _on_player_shoot():
	damping = .99
	var dToGoal
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
	attachedNow = false






func _on_startgame_pressed():
	gameStarted = true
