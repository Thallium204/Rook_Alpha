extends "res://classFactoryEntity.gd"
 
# Variables unique to Storage



# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]  OR  [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func configure(structureData,structType): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	structureName = structureData[0]
	structureType = structType
	internalStorage = [structureData[1]]
	# We edit the storage data
	for storage in internalStorage[0]:
		storage.insert(1,0) # At index 1 add a 0 to represent current resource amount ["Cobble",2] -> ["Cobble",0,2]
		storage.append(storage[0])
		storage[0] = ""
	shapeData = structureData[-1]
	# Set the image size
	rect_size = Vector2( ctrlFactoryFloor.tileSize * shapeData[0].size()  , ctrlFactoryFloor.tileSize * shapeData.size() )
	get_node("grdInfo").rect_size = rect_size # Scale the info grid

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure label
	get_node("labStructure").text = structureName
	
	# Update the structure image
	texture = load("res://Assets/Storage/img_"+structureName.to_lower()+".png")
	
	# Update process info
	var grdInfo = get_node("grdInfo")
	# Iterate through the input|divider|output children
	var grdInfoChildRefs = grdInfo.get_children() # Get a list of all children (input|divider|output)
	print(internalStorage)
	for childRefsPos in range( grdInfoChildRefs.size() ): # Iterate through the children by index
		
		var grdInfoChild = grdInfoChildRefs[childRefsPos] # Get current child
		var storage = internalStorage[0][childRefsPos]
		if isStorageEmpty() == true:
			grdInfoChild.get_node("texResource").texture = load("res://Assets/Resources/img_empty_"+storage[3].to_lower()+".png")
		else:
			grdInfoChild.get_node("texResource").texture = load("res://Assets/Resources/img_"+storage[0].to_lower()+".png")
		grdInfoChild.get_node("labCurrent").text = str( storage[1] )
		grdInfoChild.get_node("labCapacity").text = str( storage[2] )

func isStorageEmpty():
	for storage in internalStorage[0]:
		if storage[1] > 0:
			return false
	return true

func onStructure_Pressed(tile): # Called when our structure is pressed
	
	# Handle general
	onStructure_Pressed_General(tile)

func onStructure_Released(tile): # Called when our structure is pressed
	
	# Handle general
	onStructure_Released_General(tile)
