extends "res://metaData.gd"

# Factory Node
onready var FactoryNode = get_node("FactoryNode")
onready var vptFactoryScene = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene")
onready var ctrlFactoryFloor = vptFactoryScene.get_node("ctrlFactoryFloor")

var currentScreen = 0

var autoCraft = false

var isMenuOpen = false

var displayInfoMode = false
var moveStructureMode = "off"		# "off" | "ready" | "moving" 
var deleteStructureMode = false
var drawConnectorMode = "off"		# "off" | "ready" | "touching"
var drawConnector = {"nameID":"Standard","connectorType":"Conveyor"}
var lastTileArea = null

var infoColorModifier = 0.3

# [ nameID , internalStorage ]
var resourceBank = [
	
	["Log",			"Solid"],
	
	["Cobble",		"Solid"],
	
	["Stone",		"Solid"],
	
	["Plank",		"Solid"],
	
	["Brick",		"Solid"],
	
	["Hemp",		"Solid"],
	
	["Cermaic",		"Solid"],
	
	["Gear",		"Solid"],
	
	["Ironore",		"Solid"],
	
	["Ironclump",	"Solid"],
	
	["Coal",		"Solid"],
	
	["Water",		"Fluid"],
	
	["Power",		"Power"]
	
	]


func _process(_delta):
	pass

func getResourceType(nameID):
	for resource in resourceBank:
		if resource[0] == nameID:
			return resource[1]
	return "none"

func getStructureMeta(nameID,structureType):
	if structureType == "Processor":
		return processorBank["meta"+nameID].duplicate(true)
	elif structureType == "Holder":
		return holderBank["meta"+nameID].duplicate(true)
	elif structureType == "Enhancer":
		return enhancerBank["meta"+nameID].duplicate(true)

func getConnectorMeta(nameID,connectorType):
	if connectorType == "Conveyor":
		return conveyorBank["meta"+nameID].duplicate(true)
	if connectorType == "Pipe":
		return pipeBank["meta"+nameID].duplicate(true)
	if connectorType == "Cable":
		return cableBank["meta"+nameID].duplicate(true)

func initialseStructureData(nameID,structureType):
	var structureData = getStructureMeta(nameID,structureType)
	# Send the buildingData off to the FactoryFloor to be made into a child node
	ctrlFactoryFloor.addStructure(structureData,structureType)



func initialseConnectorData(entityTile):
	if drawConnector["nameID"] == "":
		return
	var connectorData = getConnectorMeta(drawConnector["nameID"],drawConnector["connectorType"])
	# Send the buildingData off to the FactoryFloor to be made into a child node
	ctrlFactoryFloor.addConnector(connectorData,drawConnector["connectorType"],entityTile)










