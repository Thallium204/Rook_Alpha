extends "res://Scripts/classFactoryStructure.gd"

onready var timeProcess = $timeProcess
onready var prgProcess = $prgProcess
onready var sprStructure = $sprStructure

# Variables unique to Buildings
var processesData = []
var processNames = []
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
	
	processesData = processorData["processesData"]
	for name in processesData:
		processNames.append(name)
	
	for upgradeInfo in processorData["upgradeData"]:
		upgrade(upgradeInfo)
	
	updateTimers()
	
	configure_Structure(processorData)
	
	prgProcess.rect_scale = entitySize/64 # Scale the progress bar

func upgrade(upgInfo):
	
	if upgInfo.has("outputBuffers"):
		#print("done")
		processesData[upgInfo["outputBuffers"][0]["resourceName"]] = (upgInfo)
		processNames.append(upgInfo["outputBuffers"][0]["resourceName"])
		return
	
	var refs = upgInfo["reference"]
	var info = upgInfo["info"]
	
	if refs[0] == "name": # If it's editing name
		entityName = info
	
	else: # If it's editing processesData
		#print(processesData)
		# Adding input/output buffer
		if refs[-1] == "inputBuffers" or refs[-1] == "outputBuffers":
			processesData[refs[0]][refs[1]].append(info)
		
		# Modifying processTime
		elif refs[-1] == "processTime":
			processesData[refs[0]][refs[1]] += info
			updateTimers()
		
		# Anything else
		else: 
			processesData[refs[0]][refs[1]][refs[2]][refs[3]] += info
	

func updateTimers():
	for process in processesData.values():
		timeProcess.stop()
		timeProcess.wait_time = process["processTime"]
		if isProcessing:
			timeProcess.start()

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	sprStructure.frames = load(imageDirectory+"/img_"+entityName.to_lower()+".tres")
	sprStructure.animation = "idle"
	sprStructure.position[1] = -sprStructure.frames.get_frame("idle",0).get_size()[1] + entitySize[1]

#func inputResource(resName,resType):
#	return inputResource_Structure(resName,resType,processesData[processIndex]["inputBuffers"])

func getInputBuffers():
	return processesData[processNames[processIndex]]["inputBuffers"]

func getOutputBuffers():
	return processesData[processNames[processIndex]]["outputBuffers"]

func _process(_delta):
	
#	$netIDs.text = ""
#	for ID in networkIDs:
#		$netIDs.text += str(ID)
	
	if isProcessing:
		progPerc = (timeProcess.wait_time-timeProcess.time_left)/float(processesData[processNames[processIndex]]["processTime"])
		get_node("prgProcess").value = stepify(100*progPerc,0.1)
	
	if Globals.autoCraft == true and get_parent():
		tryToProcess()
	
	for outputBuffer in processesData[processNames[processIndex]]["outputBuffers"]:
		if outputBuffer["bufferCurrent"] > 0:
			outputResource(outputBuffer)

func tryToProcess():
	
	if isProcessing == true:
		return
	
	if haveEnoughResources() == true: # If we have the resources needed to process
		if haveEnoughStorage() == true:
			# Deduct resource costs
			for inputBuffer in processesData[processNames[processIndex]]["inputBuffers"]:
				inputBuffer["bufferCurrent"] -= inputBuffer["bufferMax"]
				inputBuffer["bufferPotential"] = inputBuffer["bufferCurrent"]
			# Commense Processing
			isProcessing = true
			sprStructure.animation = "process"
			timeProcess.start()
#	else: # If we need resources
#		sendRequest(generateRequest("process"))

func haveEnoughResources():
	for inputBuffer in processesData[processNames[processIndex]]["inputBuffers"]:
		if inputBuffer["bufferCurrent"] < inputBuffer["bufferMax"]:
			return false
	return true

func haveEnoughStorage():
	for outputBuffer in processesData[processNames[processIndex]]["outputBuffers"]:
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

func _on_timeProcess_timeout():
	for outputBuffer in processesData[processNames[processIndex]]["outputBuffers"]:
		outputBuffer["bufferCurrent"] += outputBuffer["bufferMax"] # Gain resources
	isProcessing = false
	sprStructure.animation = "idle"
	get_node("prgProcess").value = 0
	updateUI()













