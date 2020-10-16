#Store global parameters and events
extends Node

#Nodes
var gui
var puzzle
var audio
#Parameters
var cameraSize = 40
var cameraSizeLandscape = 40
var cameraSizePortrait = 60
var level = 1   #Current level
var levels = []  #Played levels
var maxLevel = 31
var muted = false
var spriteSheet
var unplayedTexture
var cellSize

func _ready():
	cam_size()
	load_game()

#Adjust camera size
func cam_size():
	var window_size = OS.window_size
	#Landscape mode
	if window_size.x > window_size.y:
		cameraSize = cameraSizeLandscape
	#Portrait mode
	else:
		cameraSize = cameraSizePortrait

#Muting and unmuting sound
func mute(mute_state):
	muted = mute_state
	audio.toggle_music()
	audio.play("Click")

#After receiving the first input
func start_game():
	gui.animation("Start")

#Win animation
func win():
	gui.animation("Win")
	audio.play("Win")
	if !levels.has(level):
		levels.append(level)
	level+=1
	gui.gen_level_menu()
	save_game()

#Load next level or custom level
func play_level(custom_level=null):
	if custom_level:
		level = custom_level
	#End game if no more levels
	if level > maxLevel:
		end()
		return
	#Animation and sounds
	if !custom_level:
		gui.animation("Next")
	audio.play("Click")
	#Generate new level
	puzzle.load_level(level)

#Titles
func end():
	pass
	#gui.animation("End")

#Reset game and start from level 1
func reset():
	level = 1
	save_game()
	get_tree().change_scene("res://App.tscn")

#Saving
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_data = {"levels": levels}
	save_game.store_line(to_json(save_data))
	save_game.close()

#Loading 
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var save_data = parse_json(save_game.get_line())
	levels = save_data["levels"]
	if levels.size() > 0:
		level = levels[-1]+1
	#Start from the first level if no more levels
	if level > maxLevel:
		level = 1
	save_game.close()
