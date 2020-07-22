extends Node2D

onready var FactoryFloor = get_node("FactoryFloor")
onready var grdAddBuildings = get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddBuildings/grdAddBuildings")
onready var grdAddStorage = get_node("TopBarNode/btnBuildingMenu/texBuildingMenu/scrAddStorage/grdAddStorage")

onready var isMenuOpen = false

# [ nameId , inputRes ,outputRes , processTime ]
var buildingBank = [
	[ "Quarry",		[],				["Cobble",3],	12 ],
	[ "Furnace",	[["Cobble",1]],	["Stone",1],	24 ],
	[ "Table",		[["Log",1]],	["Planks",4],		6 ],
	[ "Cartography",[["Planks",2]],	["Water",1],		6 ],
	[ "Library",	[["Water",2]],	["Stone",1],		6 ],
	[ "Loom",		[["Planks",1]],	["Power",8],		6 ],
	[ "Portal",		[["Power",16]],	["Water",8],		6 ],
	[ "Spawner",	[["Cobble",2],["Water",4],["Power",9]],	["Log",64],		6 ],
	[ "Mystery",	[["Power",2],["Water",4]],	["Power",3],		6 ]
]

# [ nameId , internalStorage ]
var storageBank = [
	["Chest","Cobble",8],
	["Tank","Water",8],
	["Battery","Power",8]
	]
	


func _ready():
	initialse_AddBuildingButtons()
	initialse_AddStorageButtons()

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

func initialse_AddBuildingButtons():
	for buildingData in buildingBank:
		grdAddBuildings.addBuildingAddButton(buildingData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
	
func initialse_AddStorageButtons():
	for storageData in storageBank:
		grdAddStorage.addStorageAddButton(storageData[0]) # Send the nameID of every building to grdAddButtons to be made into a child node
