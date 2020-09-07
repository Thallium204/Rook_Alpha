extends "res://Scripts/classFactoryConnector.gd"

var pipeSpeed = 0.0

func _ready():
	imageDirectory += "/Pipe"
	entityClass = "Pipe"

func configure(pipeData): # Called when we want to initialise the internal structure
	
	pipeSpeed = pipeData["pipeSpeed"]
	$sprC.texture = load(imageDirectory+"/"+pipeData["nameID"]+"/img_center.png")
	for dire in direSprites:
		dire.texture = load(imageDirectory+"/"+pipeData["nameID"]+"/img_side.png")
	
	configure_Connector(pipeData)

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
