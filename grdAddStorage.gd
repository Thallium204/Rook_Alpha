extends HBoxContainer

onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

func addStorageAddButton(nameID):
	# Creating the building from template
	var newStorageButton = templateNode.get_node("tmpAddStorage").duplicate() # Create new add building button from template as a variable
	newStorageButton.set_name("texAdd"+nameID) # Set correctly formated name i.e. "Quarry" -> "texQuarry2"
	newStorageButton.texture = load("res://Sprites/Storage/img_"+nameID.to_lower()+".png") # Set texture based upon nameID
	add_child(newStorageButton) # Create the actual node as a child of FactoryFloor (Grid)
