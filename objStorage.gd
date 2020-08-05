extends "res://classFactoryEntity.gd"
 
# Variables unique to Storage

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure label
	get_node("labStructure").text = structureName
	
	# Update the structure image
	texture = load("res://Assets/Storage/img_"+structureName.to_lower()+".png")
	
	# Update process info
	var grdInfo = get_node("grdInfo")
	# Iterate through the input|divider|output children
	var grdInfoChildRefs = grdInfo.get_children() # Get a list of all children (input|divider|output)
	for childRefsPos in range( grdInfoChildRefs.size() ): # Iterate through the children by index
		
		var grdInfoChild = grdInfoChildRefs[childRefsPos] # Get current child
		
		grdInfoChild.get_node("labCurrent").text = str( internalStorage[0][childRefsPos][1] )
		grdInfoChild.get_node("labCapacity").text = str( internalStorage[0][childRefsPos][2] )
