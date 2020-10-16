#GUI manager
extends Control

#Link to global, update level info
func _ready():
	Global.gui = self
	gen_level_menu()


#Playing requested animation
func animation(anim_name, backwards=false):
	if backwards:
		$AnimationPlayer.play_backwards(anim_name)
	else:
		$AnimationPlayer.play(anim_name)

#Generate level atlas texture
func get_level_texture(level):
	var cellSize = Global.cellSize
	var spriteSheet = Global.spriteSheet
	#Count columns
	var columns = spriteSheet.get_size().x/cellSize
	#Get row
	var row = 0
	level -= 1
	if level > columns-1:
		row = int(level/columns)
	#Get column
	var column = level-row*columns
	#Return start position
	var start = Vector2(column,row)*cellSize
	#Create new atlas texture
	var texture = AtlasTexture.new()
	texture.atlas = spriteSheet
	texture.region = Rect2(start.x, start.y, cellSize, cellSize)

	return texture

#Generate level menu
func gen_level_menu():
	var level_grid = $LevelMenu/Center/LevelGrid
	var template_level = $LevelMenu/Center/LevelGrid/TemplateLevel
	template_level.hide()
	#Clear levels
	for level in level_grid.get_children():
		if level.name == "TemplateLevel":
			continue
		level.queue_free()
	#Add levels to grid
	for level in range(1,Global.maxLevel+1):
		#Duplicate template
		var new_level = template_level.duplicate()
		var new_label = new_level.get_node("Label")
		#Set label
		new_label.text = str(level)
		#If level is unplayed
		if not level in Global.levels:
			new_level.texture_normal = Global.unplayedTexture
		#If level is played
		else:
			var level_texture = get_level_texture(level)
			new_level.texture_normal = level_texture
			new_label.hide()
			new_level.self_modulate.a = 1
		#Add level to scene and show it
		level_grid.add_child(new_level)
		new_level.show()
		#Connect signal
		new_level.connect("pressed", self, "_on_Level_selected", [level])


#Buttons
func _on_Next_button_down():
	Global.play_level()

func _on_Sound_toggled(button_pressed):
	Global.mute(button_pressed)

func _on_Reset_button_down():
	Global.reset()

func _on_Menu_button_down():
	Global.audio.play("Click")
	#Show about menu
	if $Menu.pressed:
		$About.show()
		$LevelMenu.hide()
	#Show level menu
	else:
		$About.hide()
		$LevelMenu.show()
	$Close.show()

#Close everything
func _on_Close_button_down():
	Global.audio.play("Click")
	$Menu.pressed = false
	$LevelMenu.hide()
	$Close.hide()
	$About.hide()


func _on_Level_selected(index):
	Global.audio.play("Click")
	Global.play_level(index)
	_on_Close_button_down()
