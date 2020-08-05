extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactorySpace = get_node("../FactorySpace")
onready var camFactory = get_node("../camFactory")

var gridCols = 9
var gridRows = 18
var pointerArray = []

var entityCount = 0

var tileSize = 4*( 32 )

func _ready():
	
	# Initialise the pointerArray
	for _row in range(gridRows):
		var rowToAdd = []
		for _col in range(gridCols):
			rowToAdd.append(null)
		pointerArray.append(rowToAdd)
	
	# Initialise the background size
	FactorySpace.rect_size = tileSize * Vector2(gridCols,gridRows)

# This process ONLY adds the node structure not specifics
# (e.g. adds input, Divider and Output Storage nodes but doesn't update the amounts)
# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]
# structureData = [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func addStructure(structureData,structType):
	
	Globals.buildMode = true
	
	# Get the structure template
	var newStructure = templateNode.get_node("tmpStructure").duplicate()
	newStructure.name = structureData[0]+str(entityCount)
	entityCount += 1
	
	# We need to correctly size the structure name label ( Quarry )
	var newStructure_Label = newStructure.get_node("labStructure")
	newStructure_Label.rect_position = Vector2(0,newStructure.rect_size[1]/2) # Set the label position
	newStructure_Label.rect_size = Vector2(newStructure.rect_size[0],newStructure.rect_size[1]/2) # Set the label size
	
	# We need to set the structure position ( 500 , 400 )
	newStructure.rect_position = Vector2(0,0)
	
	# Here we add the info
	var newStructure_Info = newStructure.get_node("grdInfo") # Get the grdInfo node
	if structType == "Building": # If this is a building we need to add input storage, a process divider and output storage
		
		# Add the circle process progress bar
		var newProgress = templateNode.get_node("tmpProgress").duplicate()
		newProgress.rect_position = Vector2.ZERO
		newStructure.add_child(newProgress)
		
		# We need to add input storage ( 0/3 img_stone )
		for input in structureData[1]: # For each resource cost
			var newStorage = templateNode.get_node("tmpStorage").duplicate()
			newStorage.name = "input"+input[0]
			newStructure_Info.add_child(newStorage) # Add the input storage UI
			
		# We need to add process divider ( --[3ms]--> )
		var newProcess = templateNode.get_node("tmpProcess").duplicate()
		newProcess.name = "divider"
		newStructure_Info.add_child(newProcess) # Add the process divider UI
		
		# We need to add output storage ( 0/2 img_log )
		for output in structureData[2]:
			var newStorage = templateNode.get_node("tmpStorage").duplicate()
			newStorage.name = "output"+output[0]
			newStructure_Info.add_child(newStorage)
		
		# We need to connect the building script
		newStructure.script = load("res://objBuilding.gd")
	
	elif structType == "Storage": # If this is storage we need to add io storage
		
		# We need to add io storage ( 0/64 img_empty_solid )
		for _output in structureData[1]:
			var newStorage = templateNode.get_node("tmpStorage").duplicate()
			newStorage.name = "input|ouput"
			newStructure_Info.add_child(newStorage)
		
		# We need to connect the storage script
		newStructure.script = load("res://objStorage.gd")
	
	add_child(newStructure)
	
	newStructure.configure(structureData,structType)
	newStructure.updateUI()
	newStructure.enable_moveMode()

func addConveyor(_conveyorData,_conveyorPair):
	Globals.buildMode = true
	







