extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var nameID = null # Name of the building i.e. "Foundry3"
var buildingID = null
var gridPosition = null
var inputResList = null # List of input resources i.e. [ ["Cobble",0,4] , ["Planks",0,2] ]
var outputResList = null # List of output resources i.e. [ nameID , curResAmount , internalBuffer , resYield] = [ ["Piston",0,4,1] ]
var processTime = null # Time taken to complete a single process
var inputBuildingIDList = [] # nameIDs of all input buildings 
var outputBuildingIDList = [] # nameIDs of all output buildings
var levelData = [] # List of all upgrade modifiers

var UIPermission = true
var checkForMovement = false
var hasMoved = false

var isProcessing = false
var processTimer = 0.0 # Process timer (in seconds)
var progPerc = 0

# Call every time we want to update the UI
func configureBuildingData(buildingData):
	nameID = buildingData[0]
	inputResList = []
	outputResList = []
	for resCost in buildingData[1]:
		inputResList.append([resCost[0],0,resCost[1]])
	outputResList = [buildingData[2][0],0,4*buildingData[2][1],buildingData[2][1]]
	processTime = buildingData[3]
	updateBuildingUI()


func updateBuildingUI():
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
		get_node("labBuilding").visible = false
		self.self_modulate = Color(0.4,0.4,0.4)
	else:
		get_node("grdResCostList").visible = false
		get_node("labBuilding").visible = true
		self.self_modulate = Color(1,1,1)

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
			updateBuildingUI()
			isProcessing = false
			processTimer = 0.0
		else: # If we are still processing
			progPerc = processTimer/float(processTime)
			self.self_modulate = Color(1-progPerc,1,1-progPerc)


func _input(event):
	if checkForMovement == true:
		if event is InputEventMouseMotion:
			hasMoved = true


# WHEN THE BUILDING IS TAPPED
func _on_btnProcess_released():
	checkForMovement = false
	if hasMoved == false:
		if UIPermission == true and Globals.addConveyorMode == false: # Do we have no UI Windows open and no Conveyor select
			# Check if we have required resources
			if haveEnoughResources() == true and haveEnoughStorage() == true and isProcessing == false:
				
				# Deduct resource costs
				for resCost in inputResList:
					resCost[1] -= resCost[2]
				
				# Commense Processing
				isProcessing = true
				
	hasMoved = false
	
	# If we're creating a conveyor
	if Globals.addConveyorMode == true:
		if Globals.conveyorPair[0] == null: # If we're the first selection (FROM)
			Globals.conveyorPair[0] = self.name
		elif Globals.conveyorPair[1] == null: # If we're the second selection (TO)
			Globals.conveyorPair[1] = self.name
			Globals.initialiseConveyorData()

func _on_btnProcess_pressed():
	checkForMovement = true
