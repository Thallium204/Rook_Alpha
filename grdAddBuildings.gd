extends HBoxContainer

onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

func addBuildingAddButton(nameID):
	# Creating the building from template
	var newBuildingButton = templateNode.get_node("tmpAddBuilding").duplicate() # Create new add building button from template as a variable
	newBuildingButton.set_name("texAdd"+nameID) # Set correctly formated name i.e. "Quarry" -> "texQuarry2"
	newBuildingButton.texture = load("res://Assets/Building/img_"+nameID.to_lower()+".png") # Set texture based upon nameID
	add_child(newBuildingButton) # Create the actual node as a child of FactoryFloor (Grid)
