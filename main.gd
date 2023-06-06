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
var countright = false
var countleft = false
var countpower = false
var rightValue = 0
var leftValue = 0
var powerValue = 0
var pens = false
var counter = 0
var stop = false
var startCounting = false
signal waitscore
signal penswin
signal lost1
signal attached
signal scored
signal shooting
signal tmLoc(loc)
func _ready() -> void:
	player = get_node("Player")
	soccerBall = get_node("soccerball")

func _physics_process(delta: float) -> void:
	if startCounting:
		counter += delta
		if counter >= 2:
			emit_signal("penswin")
	if countright:
		rightValue+=delta*10
	if countleft:
		leftValue+=delta*10
	if countpower:
		powerValue+=delta*100
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
	if score == false || pens:
		if stop == false:
			soccerBall.move_and_collide(currentVelocity * delta)
	if soccerBall.position.y < 67 && soccerBall.position.x >129 && soccerBall.position.x < 193:
		if score == false && gameStarted:
			get_node("soccerball").position = Vector2(171,161)
			emit_signal("scored")
			gameStarted = false
			score = true
		if pens:
			emit_signal("waitscore")
			startCounting = true
			gameStarted = false
			score = true
			stop = true
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
	emit_signal("shooting")
	attachedNow = false




func penalty_setup():
	currentVelocity = Vector2(0,0)
	get_node("en1").position = Vector2(1000,116)
	get_node("en2").position = Vector2(1020,116)
	get_node("en3").position = Vector2(1030,116)
	get_node("en4").position = Vector2(1040,116)
	get_node("en5").position = Vector2(1050,116)
	get_node("en6").position = Vector2(1070,116)
	get_node("goalie").position = Vector2(162.5,68)
	
	get_node("soccerball").position = Vector2(160,130)
	
	get_node("Player").position = Vector2(160,130)
	
	get_node("tm1").position = Vector2(1110,116)
	get_node("tm2").position = Vector2(1143,116)
	get_node("tm3").position = Vector2(1438,116)
	get_node("tm4").position = Vector2(1632,116)
	get_node("tm5").position = Vector2(1572,116)

func _on_startgame_pressed():
	currentVelocity = Vector2(0,0)
	gameStarted = true
	get_node("en1").position = Vector2(212,116)
	get_node("en2").position = Vector2(162,111)
	get_node("en3").position = Vector2(124,107)
	get_node("en4").position = Vector2(118,82)
	get_node("en5").position = Vector2(166,88)
	get_node("en6").position = Vector2(205,80)
	get_node("goalie").position = Vector2(162.5,68)
	get_node("soccerball").position = Vector2(171,161)
	
	get_node("Player").position = Vector2(186,164)
	
	get_node("tm1").position = Vector2(227,131)
	get_node("tm2").position = Vector2(126,160)
	get_node("tm3").position = Vector2(104,123)
	get_node("tm4").position = Vector2(99,90)
	get_node("tm5").position = Vector2(225,97)


func resetConditions():
	currentVelocity = Vector2(0,0)
	gameStarted = false
	timerValue = 15
	
func _on_en_1_lose_game():
	emit_signal("lost1")
	resetConditions()


func _on_en_2_lose_game():
	emit_signal("lost1")
	resetConditions()


func _on_en_3_lose_game():
	emit_signal("lost1")
	resetConditions()


func _on_en_4_lose_game():
	emit_signal("lost1")
	resetConditions()


func _on_en_5_lose_game():
	emit_signal("lost1")
	resetConditions()


func _on_en_6_lose_game():
	emit_signal("lost1")
	resetConditions()


func _on_goalie_saved():
	emit_signal("lost1")
	resetConditions()


func _on_button_pressed():
	get_node("scoreboard").visible = false
	penalty_setup()


func _on_right_button_down():
	countright = true


func _on_right_button_up():
	countright = false


func _on_left_button_down():
	countleft = true


func _on_left_button_up():
	countleft = false


func _on_power_button_down():
	countpower = true


func _on_power_button_up():
	countpower = false


func _on_player_penshot():
	pens = true
	var rRads = deg_to_rad(rightValue)
	var lRads = deg_to_rad(leftValue)
	var rCos = cos(rRads)
	var lCos = cos(lRads)
	var rSin = sin(rRads)
	var lSin = sin(lRads)
	var directiontomid = goalMID-Vector2(160,96)
	var direc: Vector2
	if lSin == 0:
		direc = Vector2(rCos,rSin)*directiontomid
	else:
		direc = Vector2(-lCos,lSin)*directiontomid
	currentVelocity = direc * 60
	
