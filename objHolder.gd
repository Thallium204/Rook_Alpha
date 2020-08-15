extends "res://classFactoryStructure.gd"
 
# Variables unique to Storage



func _ready():
	imageDirectory += "/Holder"

# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]  OR  [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func configure(structureData,structType): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	structureName = structureData[0]
	structureType = structType
	internalStorage = [structureData[1]]
	# We edit the storage data
	for internal in internalStorage:
		for storage in internal:
			storage.insert(1,0) # At index 1 add a 0 to represent current resource amount ["Cobble",2] -> ["Cobble",0,2]
			storage.append(storage[0])
			storage[0] = ""
		
	entityShape = structureData[-1]
	#mouse_filter = Control.MOUSE_FILTER_PASS
	
	setEntitySize([entityShape[0].size(),entityShape.size()])

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	$sprStructure.texture = load(imageDirectory+"/img_"+structureName.to_lower()+".png")

func inputResource(resourceName):
	print(self.name)
	for inputData in internalStorage[0]: # Scan through input resource options
		if resourceName == inputData[0] or inputData[0] == "": #  If we have found the corresponding resource option
			if inputData[1] < inputData[2]: # If there's room
				inputData[1] += 1
				inputData[0] = resourceName
				return true
	return false # We could not add the resource for whatever reason

func pullResource(conveyorNode):
	
	# Add the conveyor node to the toList if it's not already there
	if not(conveyorNode in exportList):
		exportList.append(conveyorNode)
	
	# If it's our turn to be output to
	#if toList[toPointer] == self:
	if true:
		if internalStorage[-1][0][1] != 0:
			internalStorage[-1][0][1] -= 1
			ctrlFactoryFloor.spawnResource(["Resource"], conveyorNode.rect_position+Vector2(16,16), internalStorage[-1][0][0])
			return true
	return false

func isStorageEmpty():
	for storage in internalStorage[0]:
		if storage[1] > 0:
			return false
	return true

func onPressed(tile): # Pressed Processes for all Holders
	
	# Handle structure
	onPressed_Structure(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return

func onReleased(tile): # Released Processes for all Holders

	# Handle structure
	onReleased_Structure(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return
