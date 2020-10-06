#Puzzle controler
extends Spatial

#Movement settings
export var speed = 3
export var rotationSnap = 0.2
export var sensivity = 0.01 #swipe sensivity

#Global variables
var axis = Vector2.ZERO
var drag = Vector2.ZERO
var orbs = []
var groupDirections = [Vector3.ZERO, Vector3.ZERO]
var state = "Ready"
var toWin = 1
var touch = false
var spriteSheet
var cellSize = 16
var level = 1

#Link to global, assign global variables, load level and run process
func _ready():
	Global.puzzle = self
	level = Global.level
	spriteSheet = Global.spriteSheet
	cellSize = Global.cellSize
	load_level(level)
	set_process(true)

#Controls
func _unhandled_input(event):
	#Stop if no touch
	if !touch:
		axis = Vector2.ZERO
	#Keyboard contorls
	if Input.is_action_pressed("ui_up"):
		touch = false
		axis.y -= speed
	if Input.is_action_pressed("ui_down"):
		touch = false
		axis.y += speed
	if Input.is_action_pressed("ui_left"):
		touch = false
		axis.x -= speed
	if Input.is_action_pressed("ui_right"):
		touch = false
		axis.x += speed
	#Mouse controls
	#set axis speed on drag.
	if event is InputEventScreenDrag:
		#apply sensivity
		var pos = event.speed * sensivity
		#if sensivity is not too low set axis
		if pos.y or pos.x > sensivity:
			axis = pos
			touch = true
	#Start game on input start
	if axis != Vector2.ZERO and state == "Ready":
		state = "Playing"
		Global.start_game()

func _process(delta):
	#Setting fake perspective
	fake_perspective(delta)
	
	#damp axis on mouse or touch control
	if touch:
		axis.x = lerp(axis.x, 0, delta*5)
		axis.y = lerp(axis.y, 0, delta*5)
	
	#Gameover
	if state == "GameOver":
		return
	
	#Win
	if state == "Win":
		#Reset z rotation and translation
		rotation.z = lerp(rotation.z, PI, delta*5)
		for orb in orbs:
			orb.translation.z = lerp(orb.translation.z, 0, delta)
		#If z rotation is done
		if rotation.z >= PI-0.01:
			#Play animations
			$AnimationPlayer.play("Win")
			orb2pixel()
			#Reset translations and z rotation
			$Group1.translation = Vector3.ZERO
			$Group2.translation = Vector3.ZERO
			rotation.z = PI
			#Change state
			state = "GameOver"
			Global.win()
		return
		
	#Gameplay
	#Rotate towards input axis and snap
	rotate_x(axis.y*delta)
	rotate_y(axis.x*delta)
	var snapped_rotation = rotation.snapped(Vector3.ONE*rotationSnap)
	rotation = lerp(rotation, snapped_rotation, delta)
	
	#Calculate progress
	var toWinDeg = (abs(rotation.x)+abs(rotation.y))/2
	toWin = 1/(PI/2)*toWinDeg
	
	#Translate group 1 and 2, so there is only 1 possible solution
	$Group1.translation = lerp($Group1.translation, groupDirections[0]*toWin, delta*5) 
	$Group2.translation = lerp($Group2.translation, groupDirections[1]*toWin, delta*5)
	
	#If perspective is right change state to win
	if toWin < 0.001:
		state = "Win"

#Load specified level
func load_level(lvl):
	state = "Ready"
	level = lvl
	orbs = $PuzzleGenerator.generate(spriteSheet, cellSize, level)

func fake_perspective(delta):
	#resizing orbs to make pseudo 3d
	for orb in orbs:
		#size quotient depends on depth and orb's origin
		var size = (orb.get_global_transform().origin.z+cellSize/2)/cellSize+0.5
		#preventing orbs from being too small or too big
		if size > 1.5:
			size = 1.5
		elif size < 0.5:
			size = 0.5
		#make all orbs' size the same when player is close to win
		if toWin < 0.05:
			orb.scale = lerp(orb.scale, Vector3.ONE, delta)
		else:
			orb.scale = lerp(orb.scale, Vector3.ONE*size, delta*2)

#Play animation on each orb
func orb2pixel():
	for orb in orbs:
		orb.play("toSquare")
