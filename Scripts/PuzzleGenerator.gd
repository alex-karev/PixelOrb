#Generates orbs and places them as children of group 1 or 2
extends Node
#Global variables
var spriteSheet
var cellSize = 32
var level = 1
#Random Number Generator
var rng
#Nodes
var group1
var group2
var templateOrb

#Initialize
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	#Link nodes
	group1 = get_node("../Group1")
	group2 = get_node("../Group2")
	templateOrb = get_node("../TemplateOrb")

#Get start pixel on spritesheet
func get_start_point():
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
	return start

#Return matrix of pixels
func get_image():
	#Initialize parameters
	var start = get_start_point()
	var sheetImage = spriteSheet.get_data()
	sheetImage.lock()
	var image = []
	#Read image row by row, pixel by pixel
	for row in cellSize:
		var rowPixels = []
		for column in cellSize:
			#Get pixel and append to array
			var pixel = sheetImage.get_pixel(start.x+column, start.y+row)
			rowPixels.append(pixel)
		image.append(rowPixels)
	return image

#Get shape. Returns array with starts and ends of each row
func get_shape(image):
	var shape = []
	for row in image:
		var rowShape = []
		var lastPixel = Color.transparent
		var pair = []
		
		var x = 0
		for pixel in row:
			#Add to pair if alpha is different from last (works only with 0 alpha)
			if pixel.a != 0 and lastPixel.a == 0:
				pair.append(x)
			elif pixel.a == 0 and lastPixel.a != 0:
				pair.append(x)
			#if pair has 2 pixels append it to rowShape and reset pair, so another start-end can be added
			if len(pair) == 2:
				rowShape.push_back(pair.duplicate(true))
				pair = []
			#Increase x and save this pixel as last one
			x+=1
			lastPixel = pixel
		#If only one pixel found in pair
		if len(pair) == 1:
			rowShape.push_back([pair[0],cellSize])
		#Add rowShape to shape
		shape.push_back(rowShape)
	return shape

#Randomize rotation
func rotate():
	get_parent().rotation.x = rng.randf()*PI*2-PI
	get_parent().rotation.y = rng.randf()*PI*2-PI
	get_parent().rotation.z = rng.randf()*PI*2-PI
	#Randomize groups' move directions
	get_parent().groupDirections = [
		Vector3.ONE*rng.randf()*PI,
		Vector3.ONE*rng.randf()*PI
	]

#Clean scene
func clean():
	for child in group1.get_children():
		child.queue_free()
	for child in group2.get_children():
		child.queue_free()

#Generate new puzzle
func generate(newSpriteSheet, newCellSize, newLevel):
	#Prepare
	clean()
	rotate()
	
	#Init variables
	spriteSheet = newSpriteSheet
	cellSize = newCellSize
	level = newLevel
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var orbs = []
	
	#Get image pixel matrix and image shape array
	var image = get_image()
	var shape = get_shape(image)
	
	#Disable template orb
	templateOrb.visible = false
	
	#Spawn orbs row by row, column by column
	var y = 0
	for row in image:
		var x = 0
		for pixel in row:
			#Skip if pixel is alpha
			if pixel.a == 0:
				x+=1
				continue
			#Choose random pair from rowShape for this row and generate Z translation range
			var zRangePair = randi()%len(shape[y])
			var zRange = shape[y][zRangePair]
			#Random z translation
			var z = rng.randi_range(zRange[0],zRange[1])
			#Define Vector3 translation and move it to the center
			var pos3d = Vector3(x,y,z)-Vector3.ONE*cellSize/2
			#Spawn new orb
			var newOrb = templateOrb.duplicate()
			newOrb.visible = true
			var mat = newOrb.get_surface_material(0)
			var newMat = mat.duplicate()
			newMat.set_shader_param("color",pixel)
			newOrb.set_surface_material(0,newMat)
			#Add it to group 1 or 2 randomly
			if randi()%2 == 1:
				group1.add_child(newOrb)
			else:
				group2.add_child(newOrb)
			#Set transition and scale
			newOrb.translation = pos3d
			newOrb.scale = Vector3.ONE
			
			#apppend to array with all orbs
			orbs.append(newOrb)
			
			x+=1
		y+=1
	#Return array with all orb nodes
	return orbs
