extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactorySpace = get_node("../FactorySpace")
onready var camFactory = get_node("../camFactory")

var resource = preload("res://objResource.tscn")
var objFactoryTile = preload("res://objFactoryTile.tscn")

var gridCols = 9
var gridRows = 18
var pointerArray = []

var entityCount = 0

var tileSize = 1*( 32 )

func _ready():
	
	# Initialise the pointerArray and the FactoryTiles
	for row in range(gridRows):
		var rowToAdd = []
		for col in range(gridCols):
			var newFactoryTile = objFactoryTile.instance()
			newFactoryTile.tileRC = [row,col]
			add_child(newFactoryTile)
			newFactoryTile.updatePosition()
			rowToAdd.append(newFactoryTile)
		pointerArray.append(rowToAdd)
	
	
	# Initialise the background size
	FactorySpace.rect_size = tileSize * Vector2(gridCols,gridRows)

func spawnResource(structureData, spawnPosition, resourceName):
	var newResource = resource.instance()
	newResource.position = spawnPosition
	
	newResource.name = structureData[0]+str(entityCount)
	entityCount += 1
	
	newResource.resourceName = resourceName
	newResource.get_node("sprResource").texture = load("res://Assets/Resources/img_"+resourceName.to_lower()+".png")
	
	add_child(newResource)

func addStructure(structureData,structureType):
	
	# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ] for processor
	# structureData = [ nameID , ioResList, shapeData ] for holder
	# structType = "processor", "holder" or "enhancer"
	
	# We need to create the correct structure instance
	var newStructure = null
	if structureType == "Processor":
		newStructure = preload("res://objProcessor.tscn").instance()
	elif structureType == "Holder":
		newStructure = preload("res://objHolder.tscn").instance()
	elif structureType == "Enhancer":
		newStructure = preload("res://objEnhancer.tscn").instance()
	
	# Give unique name
	newStructure.position = Vector2(0,0)
	newStructure.name = structureData[0]+str(entityCount)
	entityCount += 1
	
	add_child(newStructure)
	
	newStructure.configure(structureData,structureType)
	newStructure.updateUI()
	newStructure.enable_moveMode(true)

func addConnector(tilePosition):
	
	# structureData = [ nameID , conveyorSpeed , shapeData ] for conveyor
	
	return

















