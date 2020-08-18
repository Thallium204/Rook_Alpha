extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactorySpace = get_node("FactorySpace")
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
			newFactoryTile.entityTile = {"row":row,"col":col}
			add_child(newFactoryTile)
			newFactoryTile.updatePosition()
			rowToAdd.append(newFactoryTile)
		pointerArray.append(rowToAdd)
	
	
	# Initialise the background size
	FactorySpace.rect_size = tileSize * Vector2(gridCols,gridRows)

func spawnResource(resourceName, resourceType, outputEntity):
	
	if resourceType == "Solid":
		
		var newResource = resource.instance()
		newResource.position = outputEntity.position+Vector2(16,16)
		
		newResource.name = resourceName+str(entityCount)
		entityCount += 1
		
		newResource.resourceName = resourceName
		newResource.get_node("sprResource").texture = load("res://Assets/Resources/img_"+resourceName.to_lower()+".png")
		
		add_child(newResource)

func addStructure(structureData,structureType):
	
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
	newStructure.name = structureData["nameID"]+str(entityCount)
	entityCount += 1
	
	add_child(newStructure)
	
	newStructure.configure(structureData)
	newStructure.updateUI()
	newStructure.enable_moveMode(true)

func addConnector(connectorData,connectorType,entityTile):
	
	var newConnector = null
	if connectorType == "Conveyor":
		newConnector = preload("res://objConveyor.tscn").instance()
#	elif connectorType == "Pipe":
#		newConnector = preload("res://objPipe.tscn").instance()
#	elif connectorType == "Cable":
#		newConnector = preload("res://objCable.tscn").instance()
	
	newConnector.position = tileSize * Vector2(entityTile["col"],entityTile["row"])
	newConnector.entityMasterTile = entityTile
	add_child(newConnector)
	newConnector.addShapeToFactory(newConnector)
	newConnector.configure(connectorData)
	newConnector.updateUI()
	
	return
















