extends "res://Scripts/classFactoryConnector.gd"

var conveyorSpeed = 0.0

func _ready():
	imageDirectory += "/Conveyor"
	entityClass = "Conveyor"

func pointResource(resourceNode):
	if ioList.empty():
		return false
	ioIndex["output"] %= ioList.size()
	resourceNode.toPosition = ioList[ioIndex["output"]].position + Vector2(16,16)
	ioIndex["output"] = (ioIndex["output"]+1)%ioList.size()
	return true

func configure(conveyorData): # Called when we want to initialise the internal structure
	
	conveyorSpeed = conveyorData["conveyorSpeed"]
	$sprC.texture = load(imageDirectory+"/"+conveyorData["nameID"]+"/img_center.png")
	for dire in direSprites:
		dire.texture = load(imageDirectory+"/"+conveyorData["nameID"]+"/img_side.png")
	
	configure_Connector(conveyorData)

func upgrade(_upgradeData):
	pass

func onPressed(tile): # Pressed Processes for all Processors
	
	# Handle structure
	onPressed_Connector(tile)

func onReleased(tile): # Released Processes for all Processors
	
	if Globals.deleteStructureMode == true:
		pass
	
	# Handle structure
	onReleased_Connector(tile)



