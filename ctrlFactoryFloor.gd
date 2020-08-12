extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactorySpace = get_node("../FactorySpace")
onready var camFactory = get_node("../camFactory")

var resource = preload("res://ResourceScene.tscn")

var gridCols = 9
var gridRows = 18
var pointerArray = []

var entityCount = 0

var tileSize = 4*( 32 )

func _ready():
	
	# Initialise the pointerArray
	for _row in range(gridRows):
		var rowToAdd = []
		for _col in range(gridCols):
			rowToAdd.append(null)
		pointerArray.append(rowToAdd)
	
	# Initialise the background size
	FactorySpace.rect_size = tileSize * Vector2(gridCols,gridRows)

func spawnResource(structureData, spawnPosition):
	var newResource = resource.instance()
	newResource.name = structureData[0]+str(entityCount)
	entityCount += 1
	
	newResource.position = spawnPosition
	
	add_child(newResource)

func addStructure(structureData,structType,quickAdd=false):
	
	# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ] for buildings
	# structureData = [ nameID , inputResList = outputResList (is dumped at _process) , outputResList , shapeData ] for storage
	# structureData = [ nameID , inputResList = outputResList (is dumped at _process) , outputResList , extractionSpeed , shapeData ]
	# structType = "Building" or "Storage"
	
	# Get the structure template
	var newStructure = templateNode.get_node("tmpStructure").duplicate()
	newStructure.name = structureData[0]+str(entityCount)
	entityCount += 1
	
	# We need to set the structure position ( 500 , 400 )
	newStructure.rect_position = Vector2(0,0)
	
	# Here we add the info
	if structType == "building": # If this is a building we need to add input storage, a process divider and output storage
		
		# Add the circle process progress bar
		var newProgress = templateNode.get_node("tmpProgress").duplicate()
		newProgress.rect_position = Vector2.ZERO
		newStructure.add_child(newProgress)
		
		# We need to connect the building script
		newStructure.script = load("res://objBuilding.gd")
	
	elif structType == "storage": # If this is storage we need to add io storage
		
		# We need to connect the storage script
		newStructure.script = load("res://objStorage.gd")
	
	elif structType == "conveyor": # If this is a conveyor we need to add ...
		
		var newQuad = templateNode.get_node("tmpQuad").duplicate()
		newQuad.position = Vector2.ZERO
		newStructure.add_child(newQuad)
		
		# We need to connect the conveyor script
		newStructure.script = load("res://objConveyor.gd")
		
		pass
	
	# Add shape node
	var newShape = templateNode.get_node("tmpShape").duplicate() # Get the Shape template
	# Add shape detectors
	for row in range( structureData[-1].size() ): # For every row of our shape
		for col in range( structureData[-1][row].size() ): # For every column in that row
			if structureData[-1][row][col] != null: # If our shape is there
				var newTileDetect = templateNode.get_node("tmpTileDetect").duplicate() # Get the TileDetect template
				newTileDetect.position = Vector2( tileSize * col , tileSize * row ) # Set its position to the correct tile in our shape
				newTileDetect.gridVector = [row,col] # Tell it what local grid position it has in our shape
				newTileDetect.structureNode = newStructure # Tell it what it's structure is
				newShape.add_child(newTileDetect) # Add the TileDetect as a child
	newStructure.add_child(newShape) # Add the Shape as a child
	
	add_child(newStructure)
	
	newStructure.configure(structureData,structType)
	newStructure.updateUI()
	if quickAdd == false:
		newStructure.enable_moveMode(true)
	else:
		return newStructure


func addConveyor(originalTile,lastQuadrant="bodyQuadU"):
	
	# Get the new tile position
	var tile = originalTile
	if lastQuadrant[-1] == "U":
		tile[0] -= 1
	elif lastQuadrant[-1] == "R":
		tile[1] += 1
	elif lastQuadrant[-1] == "D":
		tile[0] += 1
	elif lastQuadrant[-1] == "L":
		tile[1] -= 1
	
	# Get the quadrant we're coming into
	var startingQuadrant = "bodyQuad?"
	if lastQuadrant == "bodyQuadU":
		startingQuadrant = "bodyQuadD"
	elif lastQuadrant == "bodyQuadR":
		startingQuadrant = "bodyQuadL"
	elif lastQuadrant == "bodyQuadD":
		startingQuadrant = "bodyQuadU"
	elif lastQuadrant == "bodyQuadL":
		startingQuadrant = "bodyQuadR"
	
	if pointerArray[tile[0]][tile[1]] == null: # If we have moved into null space
		
		# Add a new conveyor
		var newConveyor = addStructure(["Standard",		[["Solid",1]],		[["Solid",1]], 		0.5,		[[1]]],"conveyor",true)
		newConveyor.shapeData = [[tile]]
		pointerArray[tile[0]][tile[1]] = newConveyor
		newConveyor.rect_position = Vector2( tile[1]*tileSize , tile[0]* tileSize )
		newConveyor.get_node("tmpQuad").inputs.append(startingQuadrant)
	
	elif pointerArray[tile[0]][tile[1]].structureType == "conveyor": # If we have moved into a conveyor
		
		# Update it's inputs
		pointerArray[tile[0]][tile[1]].get_node("tmpQuad").addInput(startingQuadrant)

















