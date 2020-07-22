extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var nameID = null # Name of the building i.e. "Foundry3"
var resType = null
var resInventory = [0,null]
var gridPosition = null
var inputBuildingIDList = [] # nameIDs of all input buildings 
var outputBuildingIDList = [] # nameIDs of all output buildings
var levelData = [] # List of all upgrade modifiers

var UIPermission = true

func _process(_delta):
	
	if Globals.isMenuOpen == false:
		UIPermission = true
	else:
		UIPermission = false
	
	if Globals.get_node("TopBarNode/btnInfoToggle").infoIsDisplayed == true:
		get_node("grdInventory").visible = true
		self.self_modulate = Color(0.4,0.4,0.4)
	else:
		get_node("grdInventory").visible = false
		self.self_modulate = Color(1,1,1)
		

# Call every time we want to update the UI
func updateStorageData(storageData):
	nameID = storageData[0]
	resType = storageData[1]
	resInventory[1] = storageData[2]
	
	# Update resource cost and gain UI
	var grdInventory = get_node("grdInventory") # creating a reference point at the grdInventory (list of all stored resources)
	var grdResStorage = grdInventory.get_node("grdResStorage") # creating a reference point at the grdInventory (list of all stored resources)
	grdResStorage.get_node("labResGain_yield").text = str(resInventory[0])
	grdResStorage.get_node("labResGain_inv").text = str(resInventory[1])
	grdResStorage.get_node("texResGain").texture = load("res://Sprites/Resources/img_"+resType.to_lower()+".png")
	
	#Update building name text
	get_node("labStorage").text = nameID
	
