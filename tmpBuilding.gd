extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var nameID = null # Name of the building i.e. "Foundry3"
var resAmount = 0
var gridPosition = null
var inputResList = null # List of input resources i.e. [ ["Cobble",4] , ["Planks",2] ]
var outputResList = null # List of output resources i.e. [ ["Piston",1] ]
var processTime = null # Time taken to complete a single process
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
		get_node("grdResCostList").visible = true
		get_node("labBuilding").visible = false
		self.self_modulate = Color(0.4,0.4,0.4)
	else:
		get_node("grdResCostList").visible = false
		self.self_modulate = Color(1,1,1)
		get_node("labBuilding").visible = true
		

# Call every time we want to update the UI
func updateBuildingData(buildingData):
	nameID = buildingData[0]
	inputResList = buildingData[1]
	outputResList = buildingData[2]
	processTime = buildingData[3]
	
	# Update resource cost and gain UI
	var grdResCostList = get_node("grdResCostList") # creating a reference point at the grdResCostList (list of all costs)
	for resCost in inputResList: # For each resource cost we update the display
		var grdResCost = grdResCostList.get_node("grdResCost"+resCost[0]) # creating a reference point at the grdResCost (single cost)
		grdResCost.get_node("labResCost_have").text = "0" # temporary solution
		grdResCost.get_node("labResCost_need").text = str(resCost[1]) # set the text to the needed amount of resources
		grdResCost.get_node("texResCost").texture = load("res://Sprites/Resources/img_"+resCost[0].to_lower()+".png") # set the image
	# Do the same for the resource gain
	var grdResGain = grdResCostList.get_node("grdResGain")
	grdResGain.get_node("labResGain_yield").text = "0"
	grdResGain.get_node("labResGain_inv").text = str(outputResList[1])
	grdResGain.get_node("texResGain").texture = load("res://Sprites/Resources/img_"+outputResList[0].to_lower()+".png")
	
	#Update building name text
	var printNameID = ""
	if len(nameID) > 8:
		printNameID = nameID.left(8)+"."
	else:
		printNameID = nameID
	get_node("labBuilding").text = printNameID
	
# WHEN THE BUILDING IS TAPPED
func _on_btnProcess_released():
	if UIPermission == true:
		resAmount += 1
		get_node("labResource").text = str(resAmount)
