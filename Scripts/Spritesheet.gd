#Spritesheet manager
#For changing spritesheets right inside of App.tscn
extends Node

export(Texture) var spriteSheet
export(Texture) var unplayedTexture
export var cellSize: int = 16
export var items: int = 31 #Total number of items

func _ready():
	Global.spriteSheet = spriteSheet
	Global.unplayedTexture = unplayedTexture
	Global.cellSize = cellSize
	Global.maxLevel = items
