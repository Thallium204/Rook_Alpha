extends "res://classFactoryStructure.gd"

# Variables unique to Buildings
var processTime = 0 		# Time taken to complete a single process
var timer_processTime = 0.0 # Current timer
var progPerc = 0

var isProcessing = false	# General:   		True when building is processing | False when building is not processing
var autoCraft = false		# General: 			True when always trying to process | False when not always trying to process


func _ready():
	imageDirectory += "/Processor"

# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]  OR  [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func configure(structureData,structType): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	structureName = structureData[0]
	structureType = structType
	internalStorage = [structureData[1],structureData[2]]
	processTime = structureData[-2]
	# We edit the storage data
	for internal in internalStorage:
		for storage in internal:
			storage.insert(1,0) # At index 1 add a 0 to represent current resource amount ["Cobble",2] -> ["Cobble",0,2]
			storage.append(Globals.getResourceType(storage[0]))
	entityShape = structureData[-1]
	setEntitySize([entityShape[0].size(),entityShape.size()])
	$prgProcess.rect_scale = Vector2.ONE*(entitySize[0]/64) # Scale the progress bar
	#mouse_filter = Control.MOUSE_FILTER_PASS

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	$sprStructure.texture = load(imageDirectory+"/img_"+structureName.to_lower()+".png")

func inputResource(resourceName):
	for inputData in internalStorage[0]: # Scan through input resource options
		if resourceName == inputData[0]: #  If we have found the corresponding resource option
			if inputData[1] < inputData[2]: # If there's room
				inputData[1] += 1
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

func _process(delta):
	# Prevent clicking when menu is open
	if Globals.isMenuOpen == false:
		canBeTouched = true
	else:
		canBeTouched = false
	
	# IF WE ARE PROCESSING
	if isProcessing == true:
		timer_processTime += delta
		if timer_processTime >= processTime: # If we have finished
			for output in internalStorage[1]:
				output[1] += output[2] # Gain resources
			timer_processTime = 0.0
			isProcessing = false
			get_node("prgProcess").value = 0
			updateUI()
		else: # If we are still processing
			progPerc = timer_processTime/float(processTime)
			#self.self_modulate = Color(1-progPerc,1,1-progPerc)
			get_node("prgProcess").value = stepify(100*progPerc,0.1)
	
	if Globals.autoCraft == true and get_parent() != Globals.get_node("../templateNode"):
		tryToProcess()
	
	# Prevent interaction under certain conditions
	if Globals.moveStructureMode != "off" or Globals.isMenuOpen == true:
		canBeTouched = false
	else:
		canBeTouched = true

func tryToProcess():
	# Check if we have required resources
	if haveEnoughResources() == true and haveEnoughStorage() == true and isProcessing == false and moveMode == false:
		# Deduct resource costs
		for input in internalStorage[0]:
			input[1] -= input[2]
		# Commense Processing
		isProcessing = true

func haveEnoughResources():
	for input in internalStorage[0]:
		if input[1] < input[2]:
			return false
	return true

func haveEnoughStorage():
	for output in internalStorage[1]:
		if output[1] > 0:
			return false
	return true

func onPressed(tile): # Pressed Processes for all Processors
	
	# Handle structure
	onPressed_Structure(tile)

func onReleased(tile): # Released Processes for all Processors
	
	# Handle structure
	onReleased_Structure(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return
		
	# Handle Processing
	if Globals.moveStructureMode == "off" and canBeTouched == true:
		if Globals.displayInfoMode == false:
			tryToProcess()
		else:
			if texInfoBar.infoNode == self:
				tryToProcess()

