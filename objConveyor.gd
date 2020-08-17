extends "res://classFactoryConnector.gd"

onready var directionSprites = get_children()

var conveyorSpeed = 0.0

func _ready():
	imageDirectory += "/Conveyor"
	connectorType = "Conveyor"

func pointResource(resourceNode):
	if entityOutputList.empty():
		resourceNode.waiting = self
	else:
		resourceNode.toPosition = entityOutputList[indexOutputList].position + Vector2(16,16)
		indexOutputList = (indexOutputList+1)%entityOutputList.size()
		resourceNode.speed = conveyorSpeed
		resourceNode.waiting = null
	

func configure(connectData): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	entityName = connectData["nameID"]
	conveyorSpeed = connectData["conveyorSpeed"]
	setEntitySize([entityShape[0].size(),entityShape.size()])

func updateUI():
	
	for sprite in directionSprites:
		if sprite.name[-1] in directionInputList:
			sprite.texture = load(imageDirectory+"/"+entityName+"/img_input.png")
		elif sprite.name[-1] in directionOutputList:
			sprite.texture = load(imageDirectory+"/"+entityName+"/img_output.png")
		else:
			sprite.texture = load(imageDirectory+"/"+entityName+"/img_none.png")
	

func onPressed(tile): # Pressed Processes for all Processors
	
	# Handle structure
	onPressed_Connector(tile)

func onReleased(tile): # Released Processes for all Processors
	
	# Handle structure
	onReleased_Connector(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return

