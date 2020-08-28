extends Control

onready var FactorySpace = get_node("../texBackground")
onready var camFactory = get_node("../camFactory")

var testVar = 0

var resource = preload("res://Scenes/FactoryScene/objResource.tscn")
var objFactoryTile = preload("res://Scenes/FactoryScene/objFactoryTile.tscn")

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

func _process(_delta):
	$labEntities.text = str(entityCount)

func spawnResource(resourceName, resourceType, outputEntity):
	
	if resourceType == "Solid":

		var newResource = resource.instance()
		newResource.position = outputEntity.position+Vector2(16,16)
		newResource.toPosition = outputEntity.position+Vector2(16,16)
		newResource.name = resourceName+str(entityCount)
		
		newResource.resourceName = resourceName
		newResource.get_node("sprResource").texture = load("res://Assets/Resources/img_"+resourceName.to_lower()+".png")
		if outputEntity.fatherNode.currentResource == null: # The conveyor is free
			outputEntity.fatherNode.currentResource = newResource # We set this here to avoid simultaneous collision
			entityCount += 1
			add_child(newResource)
			return true
		else:
			newResource.queue_free()
			return false

func addStructure(structureData,structureType):
	
	# structType = "processor", "holder" or "enhancer"
	
	# We need to create the correct structure instance
	var load_objStructure = load("res://Scenes/FactoryScene/obj"+structureType+".tscn")
	var objStructure = load_objStructure.instance()
	
	# Set unique identifiers
	objStructure.position = Vector2(0,0)
	objStructure.name = structureData["nameID"]+str(entityCount)
	entityCount += 1
	
	add_child(objStructure)
	
	objStructure.configure(structureData)
	objStructure.updateUI()
	objStructure.enable_moveMode(true)

func addConnector(connectorData,connectorType,entityTile):
	
	if connectorData == null:
		return
	
	if Inventory.entityInv[ connectorData["nameID"] ] == 0:
		return
	
	# We need to create the correct structure instance
	var load_objConnector = load("res://Scenes/FactoryScene/obj"+connectorType+".tscn")
	var objConnector = load_objConnector.instance()
	
	# Set unique identifiers
	objConnector.position = tileSize * Vector2(entityTile["col"],entityTile["row"])
	objConnector.name = connectorType + str(entityCount)
	objConnector.entityMasterTile = entityTile
	entityCount += 1
	
	add_child(objConnector)
	
	objConnector.configure(connectorData)
	objConnector.updateUI()
	objConnector.addShapeToFactory(objConnector)


