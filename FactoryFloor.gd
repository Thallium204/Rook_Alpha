extends GridContainer

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

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
		
	# Create divider showing yield on single process
	var newResDivider = templateNode.get_node("tmpResDivider").duplicate()
	newResDivider.name = "grdResDivider"
	newBuilding.get_node("grdResCostList").add_child(newResDivider)
	
	# Create resource gain UI
	var newResGain = templateNode.get_node("tmpResGain").duplicate()
	newResGain.name = "grdResGain"
	newBuilding.get_node("grdResCostList").add_child(newResGain)
	
	# Update the new building's internals
	newBuilding.configureBuildingData(buildingData)
	
	add_child(newBuilding) # Create the actual node as a child of FactoryFloor (Grid)

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
	
	add_child(newStorage) # Create the actual node as a child of FactoryFloor (Grid)
