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
	add_to_group("Processor")

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
	
	var refs = upgInfo["reference"]
	var info = upgInfo["info"]
	
	if refs[0] == "name": # If it's editing name
		entityName = info
	
	else: # If it's editing processesData
		#print(processesData)
		# Adding input/output buffer
		if refs[-1] == "inputBuffers":
			processesData[refs[0]]["inputBuffers"].append(MetaData.configureInputBuffers([info]))
		
		elif refs[-1] == "outputBuffers":
			processesData[refs[0]]["outputBuffers"].append(MetaData.configureOutputBuffers([info]))
		
		# Modifying processTime
		elif refs[-1] == "processTime":
			processesData[refs[0]]["processTime"] += info
			updateTimers()
		
		elif refs[-1] == "yield" or refs[-1] == "cost":
			processesData[refs[0]][refs[1]][refs[2]][refs[3]] += info
			processesData[refs[0]][refs[1]][refs[2]]["max"] = ceil(processesData[refs[0]][refs[1]][refs[2]][refs[3]])
		
		# Anything else
		else: 
			processesData[refs[0]][refs[1]][refs[2]][refs[3]] += info

func unlock(procInfo):
	procInfo = MetaData.configureProcess(procInfo)
	processesData[procInfo["outputBuffers"][0]["name"]] = procInfo
	processNames.append(procInfo["outputBuffers"][0]["name"])

func updateTimers():
	for process in processesData.values():
		timeProcess.stop()
		timeProcess.set_wait_time(process["processTime"])
		if isProcessing:
			timeProcess.start()

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	sprStructure.frames = load(imageDirectory+"/img_"+entityName.to_lower()+".tres")
	sprStructure.animation = "idle"
	sprStructure.position[1] = -sprStructure.frames.get_frame("idle",0).get_size()[1] + entitySize[1]

func getInputBuffers():
	return processesData[processNames[processIndex]]["inputBuffers"]

func getOutputBuffers():
	return processesData[processNames[processIndex]]["outputBuffers"]

func _process(_delta):
	
	if isProcessing:
		progPerc = (timeProcess.wait_time-timeProcess.time_left)/float(processesData[processNames[processIndex]]["processTime"])
		get_node("prgProcess").value = stepify(100*progPerc,0.1)
	
	if Globals.autoCraft == true and get_parent():
		tryToProcess()

func tryToProcess():
	
	if isProcessing == true:
		return
	
	if haveEnoughResources() == true: # If we have the resources needed to process
		if haveEnoughStorage() == true:
			# Deduct resource costs
			spendProcessRes()
			# Commense Processing
			isProcessing = true
			sprStructure.animation = "process"
			timeProcess.start()

func haveEnoughResources():
	for inputBuffer in processesData[processNames[processIndex]]["inputBuffers"]:
		if inputBuffer["current"] < inputBuffer["max"]:
			return false
	return true

func haveEnoughStorage():
	for outputBuffer in processesData[processNames[processIndex]]["outputBuffers"]:
		if outputBuffer["current"] > 0:
			return false
	return true

func spendProcessRes():
	for inputBuffer in processesData[processNames[processIndex]]["inputBuffers"]:
		var chance = inputBuffer["cost"] - floor(inputBuffer["cost"])
		var actualCost = floor( inputBuffer["cost"] ) + floor( chance + rng.randf_range(0,1) )
		#print("Cost: ",inputBuffer["cost"]," -> ",actualCost)
		inputBuffer["current"] -= actualCost # Deduct resource
		inputBuffer["potential"] -= actualCost

func gainProcessRes():
	for outputBuffer in processesData[processNames[processIndex]]["outputBuffers"]:
		var chance = outputBuffer["yield"] - floor(outputBuffer["yield"])
		var actualYield = floor( outputBuffer["yield"] ) + floor( chance + rng.randf_range(0,1) )
		#print("Yield: ",outputBuffer["yield"]," -> ",actualYield)
		outputBuffer["current"] += actualYield # Gain resources

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
	gainProcessRes()
	isProcessing = false
	sprStructure.animation = "idle"
	get_node("prgProcess").value = 0
	updateUI()













