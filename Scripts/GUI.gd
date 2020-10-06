#GUI manager
extends Control

#Link to global, update level info
func _ready():
	Global.gui = self
	update_level()

#Playing requested animation
func animation(anim_name):
	$AnimationPlayer.play(anim_name)

#Updating level label
func update_level():
	$Level.text = "Level "+str(Global.level)

#Buttons
func _on_Next_button_down():
	Global.next_level()

func _on_Sound_toggled(button_pressed):
	Global.mute(button_pressed)

func _on_Reset_button_down():
	Global.reset()
