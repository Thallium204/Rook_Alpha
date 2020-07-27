extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryFloor = Globals.get_node("ViewportContainer/Viewport/FactorySceneNode/FactoryFloor")

var nameID = null # Name of the building i.e. "Foundry3"
var buildingID = null
var gridPosition = null
var inputResList = null # List of input resources i.e. [ ["Cobble",0,4] , ["Planks",0,2] ]
var outputResList = null # List of output resources i.e. [ nameID , curResAmount , internalBuffer , resYield] = [ ["Piston",0,4,1] ]
var processTime = null # Time taken to complete a single process
var inputBuildingIDList = [] # nameIDs of all input buildings 
var outputBuildingIDList = [] # nameIDs of all output buildings
var levelData = [] # List of all upgrade modifiers

var toList = []
var fromList = []

var UIPermission = true
var checkForMovement = false
var hasMoved = false
var autoCraft = false

var isProcessing = false
var processTimer = 0.0 # Process timer (in seconds)
var progPerc = 0

func removeSelf():
	severConveyors()
	FactoryFloor.deleteBuilding(self)

# Call every time we want to update the UI
func configureBuildingData(buildingData):
	nameID = buildingData[0]
	inputResList = []
	outputResList = []
	for resCost in buildingData[1]:
		inputResList.append([resCost[0],0,resCost[1]])
	outputResList = [buildingData[2][0],0,4*buildingData[2][1],buildingData[2][1]]
	processTime = buildingData[3]
	updateEntityUI()


func updateEntityUI():
	# Update resource cost and gain UI
	var grdResCostList = get_node("grdResCostList") # creating a reference point at the grdResCostList (list of all costs)
	for resCost in inputResList: # For each resource cost we update the display
		var grdResCost = grdResCostList.get_node("grdResCost"+resCost[0]) # creating a reference point at the grdResCost (single cost)
		grdResCost.get_node("labResCost_have").text = str(resCost[1]) # temporary solution
		grdResCost.get_node("labResCost_need").text = str(resCost[2]) # set the text to the needed amount of resources
		grdResCost.get_node("texResCost").texture = load("res://Sprites/Resources/img_"+resCost[0].to_lower()+".png") # set the image
	# Add yield value in the divider
	var grdResDivider = grdResCostList.get_node("grdResDivider")
	grdResDivider.get_node("labResGain_yield").text = "-[+"+str(outputResList[3])+"]->"
	# Do the same for the resource gain
	var grdResGain = grdResCostList.get_node("grdResGain")
	grdResGain.get_node("labResGain_internal").text = str(outputResList[1])
	grdResGain.get_node("labResGain_buffer").text = str(outputResList[2])
	grdResGain.get_node("texResGain").texture = load("res://Sprites/Resources/img_"+outputResList[0].to_lower()+".png")
	
	#Update building name text
	var printNameID = ""
	if len(nameID) > 8:
		printNameID = nameID.left(8)+"."
	else:
		printNameID = nameID
	get_node("labBuilding").text = printNameID


func haveEnoughResources():
	for resCost in inputResList:
		if resCost[1] < resCost[2]:
			return false
	return true


func haveEnoughStorage():
	if outputResList[2]-outputResList[1] < outputResList[3]: #If we don't have enough room in the buffer
		return false
	else:
		return true

func checkIfToggleUI(): # Check if info display is active
	if Globals.infoIsDisplayed == true:
		get_node("grdResCostList").visible = true
		get_node("labBuilding").visible = true
		self.self_modulate = Color(0.4,0.4,0.4)
	else:
		get_node("grdResCostList").visible = false
		get_node("labBuilding").visible = false
		self.self_modulate = Color(1,1,1)

func tryToProcess():
	# Check if we have required resources
	if haveEnoughResources() == true and haveEnoughStorage() == true and isProcessing == false:
		# Deduct resource costs
		for resCost in inputResList:
			resCost[1] -= resCost[2]
		# Commense Processing
		isProcessing = true

func _process(delta):
	
	# Prevent clicking when menu is open
	if Globals.isMenuOpen == false:
		UIPermission = true
	else:
		UIPermission = false
	
	# Check if info display is active
	checkIfToggleUI()
	
	# IF WE ARE PROCESSING
	if isProcessing == true:
		processTimer += delta
		if processTimer >= processTime: # If we have finished
			outputResList[1] += outputResList[3] # Gain resources
			processTimer = 0.0
			isProcessing = false
			get_node("texProgress").value = 0
			updateEntityUI()
		else: # If we are still processing
			progPerc = processTimer/float(processTime)
			#self.self_modulate = Color(1-progPerc,1,1-progPerc)
			get_node("texProgress").value = stepify(100*progPerc,0.1)
	
	if autoCraft == true:
		tryToProcess()



func _input(event):
	if checkForMovement == true:
		if event is InputEventMouseMotion:
			hasMoved = true


# WHEN THE BUILDING IS TAPPED
func _on_btnProcess_released():
	
	checkForMovement = false
	if hasMoved == false:
		
		if UIPermission == true and Globals.addConveyorMode == false and Globals.moveBuildingsMode == false: # Do we have no UI Windows open and no Conveyor select
			tryToProcess()
	
		# If we're creating a conveyor
		if Globals.addConveyorMode == true and UIPermission == true:
			if Globals.conveyorPair[0] == null: # If we're the first selection (FROM)
				Globals.conveyorPair[0] = self
			elif Globals.conveyorPair[1] == null and Globals.conveyorPair[0] != self: # If we're the second selection (TO) but not the first
				Globals.conveyorPair[1] = self
				Globals.initialiseConveyorData()
		
		# If we're moving building
		if Globals.moveBuildingsMode == true and UIPermission == true:
			if Globals.movePair[0] == null: # If we're the first selection (FROM)
				Globals.movePair[0] = self
			elif Globals.movePair[1] == null and Globals.movePair[0] != self: # If we're the second selection (TO) but not the first
				Globals.movePair[1] = self
				Globals.initialiseMoveData()
		
		# If we're deleting buildings
		if Globals.deleteBuildingsMode == true and UIPermission == true:
			removeSelf()
	
	hasMoved = false

func _on_btnProcess_pressed():
	checkForMovement = true

### CONVEYOR SECTION

var fromPriority = []
var toPriority = 0

func severConveyors():
	for segmentNode in fromList+toList:
		segmentNode.killFather()


func animateByPercentage(_animate,_percentage):
	pass

func getStorage():
	return outputResList

func getRoom(resName): # Used to check for potential receivers
	#print("BUILDING getRoomRequest: ",inputResList)
	for intStorage in inputResList: # Search for the relevant internal resource storage
		if intStorage[0] == resName: # If we've found it
			return intStorage[2] - intStorage[1] # return the current room avaliable
	# If we've made it this far there was no relevant storage (i.e. trying to push cobble into log generator)
	return 0 # return no room

func getResAmount(resName): # Used to check for potential pushers
	#print(self.name,": getResAmountRequest: ",resName," for ",outputResList)
	if outputResList[0] == resName: # If we have a certain resource to pull
		return outputResList[1] # return the current resource amount
	elif resName == null: # If we can pull any resource
		return outputResList[1]
	# If we've made it this far there was no relevant storage (i.e. trying to receive resources from empty storage)
	return 0 # return no resources

func editIntStorage(resName,value,io):
	if io == "input": # If we're editing the input list
		for intStorage in inputResList: # Search for the relevant internal resource storage
			if intStorage[0] == resName: # If we've found it
				intStorage[1] += value
	else:
		outputResList[1] += value

func advancePriority(type,resName=null):
	var resIndex = getResourceIndex(resName)
	if type == "FROM":
		fromPriority[resIndex] = (fromPriority[resIndex]+1)%fromList.size()
	else:
		toPriority = (toPriority+1)%toList.size()

func getResourceIndex(resName):
	for resCostPos in range(inputResList.size()):
		if inputResList[resCostPos][0] == resName:
			return resCostPos
	return null

func pushForward():
	
	if outputResList[1] > 0: # if we have something to push
		var havePushed = false
		var stopAt = int(1*toPriority) # Create a copy of the value toPriority
		while havePushed == false:
			var targetEntity = toList[toPriority] # Get new target
			# if we are the priority and there's enough room for us to push into
			if targetEntity.findPriority(outputResList[0]) == self and targetEntity.getRoom(outputResList[0]) > 0 and outputResList[1] > 0:
				var extractAmount = targetEntity.get_parent().extractAmount
				var amountToPush = min( min( targetEntity.getRoom(outputResList[0]) , outputResList[1] ) , extractAmount )
				editIntStorage(outputResList[0],-amountToPush,"output") # Take resources
				targetEntity.editIntStorage(outputResList[0],amountToPush,"input") # Push resources
				targetEntity.advancePriority("FROM",outputResList[0]) # Move fromRoundRobin for given resource
				havePushed = true
			advancePriority("TO")
			if toPriority == stopAt: # If we've tested every option and still can't push
				havePushed = true # Exit the loop

func findPriority(resID):
	var inputResIndex = getResourceIndex(resID) # Returns the index for that resources pointer/intStorage or null if there isn't one
	if inputResIndex != null: # If there's storage for our resource
		var havePriority = false
		var stopAt = int(1*fromPriority[inputResIndex]) # Create a copy of the value fromPriority
		while havePriority == false:
			var pusherEntity = fromList[fromPriority[inputResIndex]] # Get new pusher
			# if we are the priority and there's something to push to us
			if pusherEntity.toList[pusherEntity.toPriority] == self and pusherEntity.getResAmount(resID) > 0:
				return pusherEntity
			else: # if we aren't the priority or there's nothing to push to us
				advancePriority("FROM",resID) # try the next option
			if fromPriority[inputResIndex] == stopAt: # If we've tested every option and still can't push
				havePriority = true # Exit the loop
				return fromList[stopAt]

