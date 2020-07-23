extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var nameID = null # Name of the building i.e. "Foundry3"
var buildingID = null
var outputResList = [null,null,null] # List of output resources i.e. [ nameID , curResAmount , internalBuffer] = [ ["Piston",0,1] ]
var gridPosition = null
var inputBuildingIDList = [] # nameIDs of all input buildings 
var outputBuildingIDList = [] # nameIDs of all output buildings
var levelData = [] # List of all upgrade modifiers

var UIPermission = true
var checkForMovement = false
var hasMoved = false


# Call every time we want to update the UI
func configureStorageData(storageData):
	nameID = storageData[0]
	outputResList[0] = storageData[1]
	outputResList[1] = 0
	outputResList[2] = storageData[2]
	
	# Update resource cost and gain UI
	var grdInventory = get_node("grdInventory") # creating a reference point at the grdInventory (list of all stored resources)
	var grdResStorage = grdInventory.get_node("grdResStorage") # creating a reference point at the grdInventory (list of all stored resources)
	grdResStorage.get_node("labResGain_internal").text = str(outputResList[1])
	grdResStorage.get_node("labResGain_buffer").text = str(outputResList[2])
	grdResStorage.get_node("texResGain").texture = load("res://Sprites/Resources/img_"+outputResList[0].to_lower()+".png")
	
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


func _on_btnProcess_released():
	# If we're creating a conveyor
	if Globals.addConveyorMode == true:
		if Globals.conveyorPair[0] == null: # If we're the first selection (FROM)
			Globals.conveyorPair[0] = self.name
		elif Globals.conveyorPair[1] == null: # If we're the second selection (TO)
			Globals.conveyorPair[1] = self.name
			Globals.initialiseConveyorData()












