#Puzzle controler
extends Spatial

#Movement settings
export var rotationSnap = 0.2
export var dragSpeed = 0.01
export var dragDamping = 3
export var keyboardSpeed = 3

var orbs = []
var groupDirections = [Vector3.ZERO, Vector3.ZERO]
var state = "Ready"
var toWin = 1
var spriteSheet
var cellSize = 16
var level = 1
var drag = false
var axis = Vector2.ZERO

#Link to global, assign global variables, load level and run process
func _ready():
	Global.puzzle = self
	level = Global.level
	spriteSheet = Global.spriteSheet
	cellSize = Global.cellSize
	#Set camera size
	get_node("../Camera").size = Global.cameraSize
	#Load level
	load_level(level)
	set_process(true)

func _unhandled_input(event):
		#Stop if no touch
	if !drag:
		axis = Vector2.ZERO
	#Keyboard contorls
	if Input.is_action_pressed("ui_up"):
		drag = false
		axis.y -= keyboardSpeed
	if Input.is_action_pressed("ui_down"):
		drag = false
		axis.y += keyboardSpeed
	if Input.is_action_pressed("ui_left"):
		drag = false
		axis.x -= keyboardSpeed
	if Input.is_action_pressed("ui_right"):
		drag = false
		axis.x += keyboardSpeed
	#Mouse controls
	if event is InputEventScreenDrag:
		#if dragSpeed is not too low set axis
		if event.speed .y or event.speed .x > 1:
			axis = event.speed * dragSpeed
			drag = true
	#Remove 360 icon
	if axis != Vector2.ZERO and state == "Ready":
		state = "Playing"
		Global.start_game()

func _process(delta):
	#Setting fake perspective
	fake_perspective(delta)

	#Damp axis when draging
	if drag:
		axis = lerp(axis, Vector2.ZERO, delta*dragDamping)

	#Gameover
	if state == "GameOver":
		orb2pixel(delta)
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
			#Reset translations and z rotation
			$Group1.translation = Vector3.ZERO
			$Group2.translation = Vector3.ZERO
			for orb in orbs:
				orb.translation.z = 0
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
		var mat = orb.get_surface_material(0)
		var current_scale = mat.get_shader_param("scale")
		var target_scale = 1
		if toWin < 0.05:
			target_scale = lerp(current_scale, Vector2.ONE, delta)
		else:
			target_scale = lerp(current_scale, Vector2.ONE*size, delta*2)
		mat.set_shader_param("scale", target_scale)

#Make radius bigger than UV 
func orb2pixel(delta):
	for orb in orbs:
		var mat = orb.get_surface_material(0)
		var current_radius = mat.get_shader_param("radius")
		var radius = lerp(current_radius, 2, delta)
		mat.set_shader_param("radius", radius)
