extends Node2D

# Factory Node
onready var FactoryNode = get_node("FactoryNode")
onready var vptFactoryScene = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene")
onready var ctrlFactoryFloor = vptFactoryScene.get_node("ctrlFactoryFloor")

var currentScreen = 0

var addBuildingMenu = false
var addStorageMenu = false
var addConveyorMenu = false
var autoCraft = false

var isMenuOpen = false

var displayInfoMode = false
var moveStructureMode = "off"		# "off" | "ready" | "moving" 
var deleteStructureMode = false
var drawConveyorMode = "off"		# "off" | "ready" | "touching"
var spawnResourceMode = false

var infoColorModifier = 0.3

# [ nameID , inputResList , outputResList , processTime , shapeData ]
var buildingBank = [
	
	[ "Tree",		[],								[["Log",1]],		2,		[[1,1],[1,1]]				],
	
	[ "Tree_upg1",	[],								[["Log",2]],		2,		[[1,1],[1,1]]				],
	
	[ "Quarry",		[],								[["Cobble",1]],		2,		[[1,1],[1,1]]				],
	
	[ "River",		[],								[["Clay",3]],		5,		[[1,1,1],[1,1,1],[1,1,1]]	],
	
	[ "Plant",		[],								[["Hemp",2]],		3,		[[1]]						],
	
	[ "Furnace",	[["Clay",1]],					[["Brick",1]],		4,		[[1,1],[1,1]]				],
	
	[ "Workbench",	[["Log",1]],					[["Plank",2]],		3,		[[1]]						],
	
	[ "Workbench",	[["Plank",1]],					[["Gear",2]],		3,		[[1]]						],
	
	[ "Kiln",		[["Ironore",1],["Coal",1]],		[["Ironclump",1]],	8,		[[1],[1]]					],
	
	[ "Smeltery",	[["Ironclump",1]],				[["Ironingot",1]],	8,		[[1,1],[1,1]]				]
	
	]

# [ nameID , inputResList , outputResList , shapeData ]
var storageBank = [
	
	["Hole",		[["Solid",4]],			[[1,1]]	],
	
	["Hole2",		[["Solid",8]],			[[1,1],[1,1]]	]]

# [ nameID , internalStorage ]
var resourceBank = [
	
	["Log",			"Solid"],
	
	["Cobble",		"Solid"],
	
	["Stone",		"Solid"],
	
	["Plank",		"Solid"],
	
	["Brick",		"Solid"],
	
	["Hemp",		"Solid"],
	
	["Ironore",		"Solid"],
	
	["Ironclump",	"Solid"],
	
	["Coal",		"Solid"],
	
	["Water",		"Fluid"],
	
	["Power",		"Power"]
	
	]

# [ nameID , inputResList , outputResList , conveyorSpeed , shapeData]
var conveyorBank = [
	
	["Standard",		[["Solid",1]],		[["Solid",1]], 		0.5,		[[1]]]]
	
func _process(_delta):
	pass

func getResourceType(nameID):
	for resource in resourceBank:
		if resource[0] == nameID:
			return resource[1]
	return "none"

func getStructureDataByNameID(nameID):
	for buildingData in buildingBank:
		if buildingData[0] == nameID:
			return buildingData
	for storageData in storageBank:
		if storageData[0] == nameID:
			return storageData
	for conveyorData in conveyorBank:
		if conveyorData[0] == nameID:
			return conveyorData
	return null

### INITIALISE FACTORY NODES

# PASS BUILDING DATA TO FACTORY FLOOR
func initialseStructureData(nameID,structureType):
	# Get the list data for matching nameID i.e. nameID = "Quarry" -> ["Quarry",[],["Cobble",3],...]
	var structureData = getStructureDataByNameID(nameID)
	# Send the buildingData off to the FactoryFloor to be made into a child node
	ctrlFactoryFloor.addStructure(structureData.duplicate(true),structureType)

