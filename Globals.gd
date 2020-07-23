extends Node2D

onready var FactoryFloor = get_node("FactoryFloor")
onready var ConveyorsNode = get_node("ConveyorsNode")
onready var grdAddBuildings = get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddBuildings/grdAddBuildings")
onready var grdAddStorage = get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddStorage/grdAddStorage")

var isMenuOpen = false
var infoIsDisplayed = true # immediately toggled to false
var addConveyorMode = true # immediately toggled to false
var conveyorPair = [null,null]
var conveyorCrammingFactor = 3
var numberOfBuildings = 0
var autoCraft = true


# [ nameID , inputRes ,outputRes , processTime ]
var buildingBank = [
	[ "Quarry",		[],				["Cobble",1],	0.5 ],
	[ "Furnace",	[["Cobble",1]],	["Stone",1],	1 ],
	[ "Table",		[["Log",1]],	["Planks",4],		1 ],
	[ "Cartography",[],				["Log",1],		0.5 ],
	[ "Library",	[["Cobble",2],["Planks",2]],	["Power",3],		1 ],
	[ "Loom",		[["Planks",4]],	["Power",2],		1 ],
	[ "Portal",		[["Stone",2]],	["Water",1],		1 ],
	[ "Spawner",	[["Cobble",2],["Water",4],["Power",9]],	["Log",64],		1 ],
	[ "Mystery",	[["Power",2],["Water",4]],	["Power",3],		1 ]
]


# [ nameID , internalStorage ]
var storageBank = [
	["Chest","Cobble",8],
	["Tank","Water",8],
	["Battery","Power",8]
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
	print(conveyorPair)
	ConveyorsNode.addConveyor(conveyorBank[0],conveyorPair)
	conveyorPair = [null,null]

### MENU BUTTONS

func initialse_AddBuildingButtons():
	for buildingData in buildingBank:
		grdAddBuildings.addBuildingAddButton(buildingData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
	
func initialse_AddStorageButtons():
	for storageData in storageBank:
		grdAddStorage.addStorageAddButton(storageData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
