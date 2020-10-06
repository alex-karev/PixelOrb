#Manager for sfx and music
extends Node

#Link to global node
func _ready():
	Global.audio = self

#Toggling music
func toggle_music():
	if Global.muted:
		$Music.stream_paused = true
	else:
		$Music.stream_paused = false
	
#Playing sound (if not muted)
func play(sound):
	if Global.muted:
		return
	get_node(sound).play()
