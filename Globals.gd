extends Node2D

# Factory Node
onready var FactoryNode = get_node("FactoryNode")
onready var FactorySceneNode = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/FactorySceneNode")
onready var ctrlFactoryFloor = FactorySceneNode.get_node("ctrlFactoryFloor")
onready var ConveyorFloor = FactorySceneNode.get_node("ConveyorFloor")
onready var grdAddBuildings = FactoryNode.get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddBuildings/grdAddBuildings")
onready var grdAddStorage = FactoryNode.get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddStorage/grdAddStorage")

var currentScreen = 0

var isMenuOpen = false
var infoIsDisplayed = false
var infoColorModifier = 0.3
var addConveyorMode = false
var moveStructureMode = false
var deleteBuildingsMode = false
var autoCraft = false

var buildMode = false

var conveyorPair = [null,null]
var movePair = [null,null]
var conveyorSpacing = 80
var numberOfBuildings = 0


# [ nameID , inputResList , outputResList , processTime , shapeData ]
var buildingBank = [
	
	[ "Tree",		[],								[["Log",1]],		3,		[[1,1],[1,1]]	],
	
	[ "Tree_upg1",	[],								[["Log",2]],		3,		[[1,1],[1,1]]	],
	
	[ "Quarry",		[],								[["Cobble",1]],		2,		[[1,1],[1,1]]	],
	
	[ "Furnace",	[["Cobble",1]],					[["Stone",1]],		4,		[[1,1],[1,null],[null,1]]	],
	
	[ "Table",		[["Log",1]],					[["Planks",4]],		4,		[[1,1],[1,null],[null,1]]	],
	
	[ "Library",	[["Cobble",2],["Planks",2]],	[["Power",3]],		3,		[[1,1],[1,null],[null,1]]	],
	
	[ "Loom",		[["Planks",4]],					[["Power",2]],		2,		[[1,1],[1,null],[null,1]]	],
	
	[ "Portal",		[["Stone",2]],					[["Water",1]],		2,		[[1,1],[1,null],[null,1]]	],
	
	[ "Spawner",	[["Cobble",2],["Water",4]],		[["Log",64]],		10, 	[[1,1],[1,null],[null,1]]	],
	
	[ "Mystery",	[["Power",2],["Water",4]],		[["Power",3]],		2,		[[1,1],[1,null],[null,1]]	]
	
]


# [ nameID , internalStorageList , shapeData ]
var storageBank = [
	
	["Chest",		[["Solid",64]],								[[1,1],[1,null],[null,1]]	],
	
	["Tank",		[["Fluid",64]],								[[1,1],[1,null],[null,1]]	],
	
	["Battery",		[["Power",64]],								[[1,1],[1,null],[null,1]]	]
	
	#["Multi",		[["Solid",64],["Fluid",64],["Power",64]]	[[1,1],[1,null],[null,1]]	],
	
]

# [ nameID , internalStorage ]
var resourceBank = [
	
	["Log",			"Solid"],
	
	["Cobble",		"Solid"],
	
	["Stone",		"Solid"],
	
	["Planks",		"Solid"],
	
	["Water",		"Fluid"],
	
	["Power",		"Power"],
	
]

# [ nameID ,  extractAmount , conveyorSpeed , segmentBuffer ]
var conveyorBank = [
	
	["Standard", 	1, 			0.5, 		1]
	
]


func _ready():
	initialse_AddBuildingButtons()
	initialse_AddStorageButtons()
	
func _process(_delta):
	#print(Vector2(300,300)/2)
	pass

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
func initialseBuildingData(nameID):
	# Get the list data for matching nameID i.e. nameID = "Quarry" -> ["Quarry",[],["Cobble",3],...]
	var buildingData = getBuildingDataByNameID(nameID)
	ctrlFactoryFloor.addStructure(buildingData.duplicate(true),"Building") # Send the buildingData off to the FactoryFloor to be made into a child node

# PASS BUILDING DATA TO FACTORY FLOOR
func initialseStorageData(nameID):
	# Get the list data for matching nameID i.e. nameID = "Quarry" -> ["Quarry",[],["Cobble",3],...]
	var storageData = getStorageDataByNameID(nameID)
	ctrlFactoryFloor.addStructure(storageData.duplicate(true),"Storage") # Send the buildingData off to the FactoryFloor to be made into a child node

func initialiseConveyorData():
	#print(conveyorPair)
	ctrlFactoryFloor.addConveyor(conveyorBank[0],conveyorPair)
	conveyorPair = [null,null]

func initialiseMoveData():
	#print(conveyorPair)
	ctrlFactoryFloor.swapChildrenOnFloor(movePair)
	movePair = [null,null]

### MENU BUTTONS

func initialse_AddBuildingButtons():
	for buildingData in buildingBank:
		grdAddBuildings.addBuildingAddButton(buildingData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
	
func initialse_AddStorageButtons():
	for storageData in storageBank:
		grdAddStorage.addStorageAddButton(storageData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
