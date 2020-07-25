extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var nameID = null # Name of the building i.e. "Foundry3"
var buildingID = null
var intStorage = [null,0,0] # List of output resources i.e. [ nameID , curResAmount , internalBuffer] = [ ["Piston",0,1] ]
var gridPosition = null
var inputBuildingIDList = [] # nameIDs of all input buildings 
var outputBuildingIDList = [] # nameIDs of all output buildings
var levelData = [] # List of all upgrade modifiers

var toList = []
var fromList = []

var UIPermission = true
var checkForMovement = false
var hasMoved = false

func updateEntityUI():
	# Update resource cost and gain UI
	var grdInventory = get_node("grdInventory") # creating a reference point at the grdInventory (list of all stored resources)
	var grdResStorage = grdInventory.get_node("grdResStorage") # creating a reference point at the grdInventory (list of all stored resources)
	grdResStorage.get_node("labResGain_internal").text = str(intStorage[1])
	grdResStorage.get_node("labResGain_buffer").text = str(intStorage[2])
	if intStorage[1] == 0: # If our storage is empty
		grdResStorage.get_node("texResGain").texture = load("res://Sprites/Resources/img_empty.png")
	else:
		grdResStorage.get_node("texResGain").texture = load("res://Sprites/Resources/img_"+intStorage[0].to_lower()+".png")

# Call every time we want to update the UI
func configureStorageData(storageData): # i.e storageData = [ "Chest" , 8 ]
	nameID = storageData[0]
	intStorage[2] = storageData[1]
	
	# Update resource cost and gain UI
	updateEntityUI()
	
	#Update building name text
	var printNameID = ""
	if len(nameID) > 8:
		printNameID = nameID.left(8)+"."
	else:
		printNameID = nameID
	get_node("labStorage").text = printNameID


func _process(_delta):
	
	if Globals.isMenuOpen == false:
		UIPermission = true
	else:
		UIPermission = false
	
	if Globals.infoIsDisplayed == true:
		get_node("grdInventory").visible = true
		self.self_modulate = Color(0.4,0.4,0.4)
	else:
		get_node("grdInventory").visible = false
		self.self_modulate = Color(1,1,1)


func _input(event):
	if checkForMovement == true:
		if event is InputEventMouseMotion:
			hasMoved = true


# WHEN THE BUILDING IS TAPPED
func _on_btnProcess_released():
	
	checkForMovement = false
	if hasMoved == false:

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
	
	hasMoved = false




### CONVEYOR SECTION

var toPriority = 0
var fromPriority = 0

func severConveyors():
	for segmentNode in fromList+toList:
		segmentNode.killFather()

func animateByPercentage(_animate,_percentage):
	pass

func getStorage():
	return intStorage

func getRoom(resName):  # Used to check for potential receivers
	#print("SEGMENT getRoomRequest: ",intStorage)
	if intStorage[0] == resName: # If we're being given our current resource
		return intStorage[2] - intStorage[1] # return the current room avaliable
	elif intStorage[0] == null: # If the conveyor is empty
		return intStorage[2] # return maximum room
	else: # If we're being given a different resource than we have
		return 0 # return no room

func getResAmount(resName): # Used to check for potential pushers
	#print("SEGMENT getResAmountRequest: ",intStorage)
	if intStorage[0] == resName: # If we have a certain resource to pull
		return intStorage[1] # return the current resource amount
	elif resName == null: # If we can pull any resource
		return intStorage[1]
	# If we've made it this far there was no relevant storage (i.e. trying to receive resources from empty storage)
	return 0 # return no resources

func editIntStorage(resName,value,_io):
	intStorage[0] = resName
	intStorage[1] += value
	#if intStorage[1] == 0:
	#	intStorage[0] = null
	
func advancePriority(type,_resName=null):
	if type == "FROM":
		fromPriority = (fromPriority+1)%fromList.size()
	else:
		toPriority = (toPriority+1)%toList.size()

func pushForward():
	
	if intStorage[1] > 0: # if we have something to push
		var havePushed = false
		var stopAt = int(1*toPriority) # Create a copy of the value toPriority
		while havePushed == false:
			var targetEntity = toList[toPriority] # Get new target
			# if we are the priority AND there's enough room for us to push into
			if targetEntity.findPriority(intStorage[0]) == self and targetEntity.getRoom(intStorage[0]) > 0:
				var amountToPush = min( targetEntity.getRoom(intStorage[0]) , intStorage[1] )
				editIntStorage(intStorage[0],-amountToPush,"output") # Take resources
				targetEntity.editIntStorage(intStorage[0],amountToPush,"input") # Push resources
				targetEntity.advancePriority("FROM",intStorage[0]) # Move fromRoundRobin
				havePushed = true
			advancePriority("TO")
			if toPriority == stopAt: # If we've tested every option and still can't push
				havePushed = true # Exit the loop
	else:
		intStorage[0] = null

func findPriority(resID):
	var havePriority = false
	var stopAt = int(1*fromPriority) # Create a copy of the value fromPriority
	while havePriority == false:
		var pusherEntity = fromList[fromPriority] # Get new pusher
		# if we are the priority and there's something to push to us
		if pusherEntity.toList[pusherEntity.toPriority] == self and pusherEntity.getResAmount(resID) > 0:
			return pusherEntity
		else: # if we aren't the priority or there's nothing to push to us
			advancePriority("FROM") # try the next option
		if fromPriority == stopAt: # If we've tested every option and still can't push
			havePriority = true # Exit the loop
			return fromList[stopAt]







