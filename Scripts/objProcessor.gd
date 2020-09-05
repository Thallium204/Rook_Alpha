extends "res://Scripts/classFactoryStructure.gd"

# Variables unique to Buildings
var processData = []
var processIndex = 0
var timer_processTime = 0.0 # Current timer
var progPerc = 0

var delta_output = 0.0
var extractTime = 3

var isProcessing = false	# General:   		True when building is processing | False when building is not processing
var autoCraft = false		# General: 			True when always trying to process | False when not always trying to process

func _ready():
	imageDirectory += "/Processor"
	entityClass = "Processor"

func configure(processorData): # Called when we want to initialise the internal structure
	
	processData = processorData["processesData"]
	
	configure_Structure(processorData)
	
	$prgProcess.rect_scale = entitySize/64 # Scale the progress bar

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	$sprStructure.frames = load(imageDirectory+"/img_"+entityName.to_lower()+".tres")
	$sprStructure.animation = "idle"
	$sprStructure.position[1] = -$sprStructure.frames.get_frame("idle",0).get_size()[1] + entitySize[1]

#func inputResource(resName,resType):
#	return inputResource_Structure(resName,resType,processData[processIndex]["inputBuffers"])

func getInputBuffers():
	return processData[processIndex]["inputBuffers"]

func getOutputBuffers():
	return processData[processIndex]["outputBuffers"]

func _process(delta):
	
	$netIDs.text = ""
	for ID in networkIDs:
		$netIDs.text += str(ID)
	
	# IF WE ARE PROCESSING
	if isProcessing == true:
		timer_processTime += delta
		if timer_processTime >= processData[processIndex]["processTime"]: # If we have finished
			for outputBuffer in processData[processIndex]["outputBuffers"]:
				outputBuffer["bufferCurrent"] += outputBuffer["bufferMax"] # Gain resources
			timer_processTime = 0.0
			isProcessing = false
			$sprStructure.animation = "idle"
			get_node("prgProcess").value = 0
			updateUI()
		else: # If we are still processing
			progPerc = timer_processTime/float(processData[processIndex]["processTime"])
			#self.self_modulate = Color(1-progPerc,1,1-progPerc)
			get_node("prgProcess").value = stepify(100*progPerc,0.1)
	
	if Globals.autoCraft == true and get_parent():
		tryToProcess()
	
	for outputBuffer in processData[processIndex]["outputBuffers"]:
		if outputBuffer["bufferCurrent"] > 0:
			outputResource(outputBuffer)

func tryToProcess():
	
	if isProcessing == true:
		return
	
	if haveEnoughResources() == true: # If we have the resources needed to process
		if haveEnoughStorage() == true:
			# Deduct resource costs
			for inputBuffer in processData[processIndex]["inputBuffers"]:
				inputBuffer["bufferCurrent"] -= inputBuffer["bufferMax"]
				inputBuffer["bufferPotential"] = inputBuffer["bufferCurrent"]
			# Commense Processing
			isProcessing = true
			$sprStructure.animation = "process"
	else: # If we need resources
		sendRequest(generateRequest("process"))

func haveEnoughResources():
	for inputBuffer in processData[processIndex]["inputBuffers"]:
		if inputBuffer["bufferCurrent"] < inputBuffer["bufferMax"]:
			return false
	return true

func haveEnoughStorage():
	for outputBuffer in processData[processIndex]["outputBuffers"]:
		if outputBuffer["bufferCurrent"] > 0:
			return false
	return true

func onPressed(tile): # Pressed Processes for all Processors
	
	# Handle structure
	onPressed_Structure(tile)

func onReleased(tile): # Released Processes for all Processors
	
	# Handle structure
	onReleased_Structure(tile)
	
	if Globals.moveStructureMode != "off":
		return
	
	# Handle Processing
	if Globals.moveStructureMode == "off":
		if Globals.displayInfoMode == false: # If we're not in info mode
			tryToProcess() # Process as normal
		else:
			if texInfoBar.infoNode == self: # If we are in info mode
				if texInfoBar.functionYet == true: # Have we already tapped to gain info
					tryToProcess() # Process as normal
				else: # Is this is our first tap to gain info
					texInfoBar.functionYet = true

