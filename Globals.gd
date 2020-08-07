extends Node2D

# Factory Node
onready var FactoryNode = get_node("FactoryNode")
onready var vptFactoryScene = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene")
onready var ctrlFactoryFloor = vptFactoryScene.get_node("ctrlFactoryFloor")

var currentScreen = 0

var addBuildingMode = false
var addStorageMode = false
var addConveyorMode = false
var autoCraft = false

var isMenuOpen = false

var infoIsDisplayed = false
var moveStructureMode = "off"		# "off" | "ready" | "moving" 
var deleteStructureMode = false

var infoColorModifier = 0.3

# [ nameID , inputResList , outputResList , processTime , shapeData ]
var buildingBank = [
	
	[ "Tree",		[],								[["Log",1]],		3,		[[1,1],[1,1]]	],
	
	[ "Tree_upg1",	[],								[["Log",2]],		3,		[[1,1],[1,1]]	],
	
	[ "Quarry",		[],								[["Cobble",1]],		2,		[[1,1],[1,1]]	],
	
	[ "Furnace",	[["Cobble",1]],					[["Stone",1]],		4,		[[1,1],[1,1]]	],
	
	[ "Table",		[["Log",1]],					[["Planks",4]],		4,		[[1,1],[1,1]]	],
	
	[ "Library",	[["Cobble",2],["Planks",2]],	[["Power",3]],		3,		[[1,1],[1,1]]	],
	
	[ "Loom",		[["Planks",4]],					[["Power",2]],		2,		[[1,1],[1,1]]	],
	
	[ "Portal",		[["Stone",2]],					[["Water",1]],		2,		[[1,1],[1,1]]	],
	
	[ "Spawner",	[["Cobble",2],["Water",4]],		[["Log",64]],		10, 	[[1,1],[1,1]]	],
	
	[ "Mystery",	[["Power",2],["Water",4]],		[["Power",3]],		2,		[[1,1],[1,1]]	]]

# [ nameID , internalStorageList , shapeData ]
var storageBank = [
	
	["Chest",		[["Solid",64]],								[[1,1],[1,1]]	],
	
	["Tank",		[["Fluid",64]],								[[1,1],[1,1]]	],
	
	["Battery",		[["Power",64]],								[[1,1],[1,1]]	]]

# [ nameID , internalStorage ]
var resourceBank = [
	
	["Log",			"Solid"],
	
	["Cobble",		"Solid"],
	
	["Stone",		"Solid"],
	
	["Planks",		"Solid"],
	
	["Water",		"Fluid"],
	
	["Power",		"Power"]]

# [ nameID ,  extractAmount , conveyorSpeed , segmentBuffer ]
var conveyorBank = [
	
	["Standard", 	1, 			0.5, 		1]]
	
func _process(_delta):
	pass

func getResourceType(nameID):
	for resource in resourceBank:
		if resource[0] == nameID:
			return resource[1]
	return "none"

func getBuildingDataByNameID(nameID):
	for buildingData in buildingBank:
		if buildingData[0] == nameID:
			return buildingData
	return null

func getStorageDataByNameID(nameID):
	for storageData in storageBank:
		if storageData[0] == nameID:
			return storageData
	return null

### INITIALISE FACTORY NODES

# PASS BUILDING DATA TO FACTORY FLOOR
func initialseStructureData(nameID,structureType):
	print(nameID," ",structureType)
	# Get the list data for matching nameID i.e. nameID = "Quarry" -> ["Quarry",[],["Cobble",3],...]
	var structureData = null
	if structureType == "building":
		structureData = getBuildingDataByNameID(nameID)
	elif structureType == "storage":
		structureData = getStorageDataByNameID(nameID)
	# Send the buildingData off to the FactoryFloor to be made into a child node
	ctrlFactoryFloor.addStructure(structureData.duplicate(true),structureType)

func initialiseConveyorData():
	#print(conveyorPair)
	pass

