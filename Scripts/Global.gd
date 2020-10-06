#Store global parameters and events
extends Node

#Nodes
var gui
var puzzle
var audio
#Parameters
var level = 1
var maxLevel = 31
var muted = false
var spriteSheet
var cellSize

func _ready():
	load_game()

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
	level += 1
	save_game()

#Load next level
func next_level():
	#Show titles if there is no next level
	if level > maxLevel:
		end()
		return
	#Animation and sounds
	gui.animation("Next")
	gui.update_level()
	audio.play("Click")
	#Generate new level
	puzzle.load_level(level)

#Titles
func end():
	gui.animation("End")

#Reset game and start from level 1
func reset():
	level = 1
	save_game()
	get_tree().change_scene("res://App.tscn")

#Saving
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_data = {"level": level}
	save_game.store_line(to_json(save_data))
	save_game.close()

#Loading 
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var save_data = parse_json(save_game.get_line())
	level = save_data["level"]
	save_game.close()
