extends Node2D

onready var FactoryFloor = get_node("scrFactoryFloor/FactoryFloor")
onready var ConveyorFloor = get_node("scrFactoryFloor/FactoryFloor/ConveyorFloor")
onready var grdAddBuildings = get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddBuildings/grdAddBuildings")
onready var grdAddStorage = get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddStorage/grdAddStorage")

var isMenuOpen = false
var infoIsDisplayed = true # immediately toggled to false
var addConveyorMode = true # immediately toggled to false
var moveBuildingsMode = true # immediately toggled to false
var conveyorPair = [null,null]
var movePair = [null,null]
var conveyorSpacing = 80
var numberOfBuildings = 0
var autoCraft = false


# [ nameID , inputRes ,outputRes , processTime ]
var buildingBank = [
	[ "Quarry",		[],				["Cobble",1],	2 ],
	[ "Furnace",	[["Cobble",1]],	["Stone",1],	4 ],
	[ "Table",		[["Log",1]],	["Planks",4],		4 ],
	[ "Cartography",[],				["Log",1],		2 ],
	[ "Library",	[["Cobble",2],["Planks",2]],	["Power",3],		3 ],
	[ "Loom",		[["Planks",4]],	["Power",2],		2 ],
	[ "Portal",		[["Stone",2]],	["Water",1],		2 ],
	[ "Spawner",	[["Cobble",2],["Water",4],["Power",9]],	["Log",64],		10 ],
	[ "Mystery",	[["Power",2],["Water",4]],	["Power",3],		2 ]
]


# [ nameID , internalStorage ]
var storageBank = [
	["Chest",8],
	["Tank",8],
	["Battery",8]
]


# [ nameID ,  extractAmount , conveyorSpeed , segmentBuffer ]
var conveyorBank = [
	["Standard", 1, 0.5, 1]
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
	FactoryFloor.addBuilding(buildingData) # Send the buildingData off to the FactoryFloor to be made into a child node

# PASS BUILDING DATA TO FACTORY FLOOR
func initialseStorageData(nameID):
	# Get the list data for matching nameID i.e. nameID = "Quarry" -> ["Quarry",[],["Cobble",3],...]
	var storageData = getStorageDataByNameID(nameID)
	FactoryFloor.addStorage(storageData) # Send the buildingData off to the FactoryFloor to be made into a child node

func initialiseConveyorData():
	#print(conveyorPair)
	ConveyorFloor.addConveyor(conveyorBank[0],conveyorPair)
	conveyorPair = [null,null]

func initialiseMoveData():
	#print(conveyorPair)
	FactoryFloor.swapChildrenOnFloor(movePair)
	movePair = [null,null]

### MENU BUTTONS

func initialse_AddBuildingButtons():
	for buildingData in buildingBank:
		grdAddBuildings.addBuildingAddButton(buildingData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
	
func initialse_AddStorageButtons():
	for storageData in storageBank:
		grdAddStorage.addStorageAddButton(storageData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
