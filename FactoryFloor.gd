extends GridContainer

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

var buildingList = []
var initialFloorSize = 12 # Hard-coded cap to the number of buildings allowed on FactoryFloor

func _ready():
	addBuildingSpace()

func addBuildingSpace():
	for i in range(initialFloorSize):
		var newBuildingSpace = templateNode.get_node("tmpBuildingSpace").duplicate()
		newBuildingSpace.name = "space"+str(i)
		add_child(newBuildingSpace)
		buildingList.append(newBuildingSpace)

func getBuildingIndex(node):
	for buildingNodePos in range(buildingList.size()):
		if buildingList[buildingNodePos] == node:
			return buildingNodePos

func addChildToFloor(nodeToAdd):
	for buildingNodePos in range(buildingList.size()):
		if "space" in buildingList[buildingNodePos].name:
			
			remove_child(buildingList[buildingNodePos]) # Remove the child node from FactoryFloor (Grid)
			buildingList.erase(buildingList[buildingNodePos]) # Remove the child node from buildingList
			
			add_child(nodeToAdd) # Create the actual node as a child of FactoryFloor (Grid)
			buildingList.insert(buildingNodePos,nodeToAdd) # Add the child node into the buildingList at the correct index
			move_child(nodeToAdd,buildingNodePos) # Move the newly added child node to the correct index/grid_position
			
			break
	#for buildingNode in buildingList:
	#	print(buildingNode.name)

func swapChildrenOnFloor(nodeSwapPair):
	var nodeIndexPair = [ getBuildingIndex(nodeSwapPair[0]) , getBuildingIndex(nodeSwapPair[1]) ]
	
	# Destroy conveyors
	for buildingNode in nodeSwapPair:
		if "space" in buildingNode.name:
			pass
		else:
			buildingNode.severConveyors()
	
	print("\n")
	print("Swapping: ",nodeSwapPair[0].name," with ",nodeSwapPair[1].name)
	move_child(nodeSwapPair[0],nodeIndexPair[1])
	move_child(nodeSwapPair[1],nodeIndexPair[0])
	
	buildingList[nodeIndexPair[0]] = nodeSwapPair[1]
	buildingList[nodeIndexPair[1]] = nodeSwapPair[0]
	
	for buildingNode in buildingList:
		print(buildingNode.name)


func addBuilding(buildingData):
	Globals.numberOfBuildings += 1
	var nameID = buildingData[0] # Isolate the name index from buildingData
	var newBuilding = templateNode.get_node("tmpBuilding").duplicate() # Create new building from template as a variable
	newBuilding.set_name("tex"+nameID+'_'+str(Globals.numberOfBuildings)) # Set correctly formated name i.e. "Quarry" -> "texQuarry2"
	newBuilding.texture = load("res://Sprites/Buildings/img_"+nameID.to_lower()+".png") # Set texture based upon nameID
	newBuilding.buildingID = Globals.numberOfBuildings
	
	# Create resource cost UI
	for resCost in buildingData[1]:
		var newResCost = templateNode.get_node("tmpResCost").duplicate()
		newResCost.name = "grdResCost"+resCost[0]
		newBuilding.get_node("grdResCostList").add_child(newResCost)
		newBuilding.fromPriority.append(0) # Add round robin for each resource
		
	# Create divider showing yield on single process
	var newResDivider = templateNode.get_node("tmpResDivider").duplicate()
	newResDivider.name = "grdResDivider"
	newBuilding.get_node("grdResCostList").add_child(newResDivider)
	
	# Create resource gain UI
	var newResGain = templateNode.get_node("tmpResGain").duplicate()
	newResGain.name = "grdResGain"
	newBuilding.get_node("grdResCostList").add_child(newResGain)
	
	newBuilding.autoCraft = Globals.autoCraft # Set autocraft
	
	# Update the new building's internals
	newBuilding.configureBuildingData(buildingData)
	
	addChildToFloor(newBuilding) # Create the actual node as a child of FactoryFloor (Grid)

func addStorage(storageData):
	Globals.numberOfBuildings += 1
	var nameID = storageData[0] # Isolate the name index from buildingData
	var newStorage = templateNode.get_node("tmpStorage").duplicate() # Create new building from template as a variable
	newStorage.set_name("tex"+nameID+'_'+str(Globals.numberOfBuildings)) # Set correctly formated name i.e. "Chest" -> "texChest7"
	newStorage.texture = load("res://Sprites/Storage/img_"+nameID.to_lower()+".png") # Set texture based upon nameID
	newStorage.buildingID = Globals.numberOfBuildings
	
	# Create storage UI
	var newResGain = templateNode.get_node("tmpResGain").duplicate()
	newResGain.name = "grdResStorage"
	newStorage.get_node("grdInventory").add_child(newResGain)
	
	newStorage.configureStorageData(storageData) # Let the new node initialse its inner variables
	
	addChildToFloor(newStorage)



