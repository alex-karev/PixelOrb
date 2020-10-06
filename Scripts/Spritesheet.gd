#Spritesheet manager
#For changing spritesheets right inside of App.tscn
extends Node

export(Texture) var spriteSheet
export var cellSize = 16
export var items = 31 #Total number of items

func _ready():
	Global.spriteSheet = spriteSheet
	Global.cellSize = cellSize
	Global.maxLevel = items
