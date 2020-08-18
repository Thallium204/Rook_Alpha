extends "res://classFactoryStructure.gd"
 
# Variables unique to Storage
var internalStorage = []

func _ready():
	imageDirectory += "/Holder"
	structureType = "Holder"

func _process(_delta):
	
	for internalBuffer in internalStorage:
		outputResource(internalBuffer["resourceName"],internalBuffer["resourceType"])

func configure(structData): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	entityName = structData["nameID"]
	internalStorage = structData["internalStorage"]
	entityShape = structData["shapeData"]
	setEntitySize([entityShape[0].size(),entityShape.size()])

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	$sprStructure.texture = load(imageDirectory+"/img_"+entityName.to_lower()+".png")

func inputResource(resourceNode):
	for internalBuffer in internalStorage: # Scan through input resource options
		if internalBuffer["resourceType"] == resourceNode.resourceType:
			#  If we have found the corresponding resource option
			if internalBuffer["resourceName"] == resourceNode.resourceName or internalBuffer["resourceName"] == "":
				if internalBuffer["bufferCurrent"] < internalBuffer["bufferMax"]: # If there's room
					internalBuffer["bufferCurrent"] += 1
					internalBuffer["resourceName"] = resourceNode.resourceName
					return true
	return false

func outputResource(resourceName,resourceType):
	if entityOutputList.empty():
		return false
	for internalBuffer in internalStorage: # Scan through input resource options
		if internalBuffer["resourceType"] == resourceType:
			#  If we have found the corresponding resource option
			if internalBuffer["resourceName"] == resourceName or internalBuffer["resourceName"] == "":
				if internalBuffer["bufferCurrent"] > 0: # If there's any resources to export
					indexOutputList = (indexOutputList+1)%entityOutputList.size() # Iterate the index
					if entityOutputList[indexOutputList].fatherNode.currentResource == null: # If the output conveyor has no resources on it
						internalBuffer["bufferCurrent"] -= 1
						ctrlFactoryFloor.spawnResource(resourceName,internalBuffer["resourceType"], entityOutputList[indexOutputList])
						if internalBuffer["bufferCurrent"] == 0:
							internalBuffer["resourceName"] = ""
						return true
					return false
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
