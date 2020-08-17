extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var ctrlFactoryFloor = Globals.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
onready var texInfoBar = Globals.get_node("FactoryNode/SideBarNode/texInfoBar")
onready var FactorySpace = ctrlFactoryFloor.get_node("../FactorySpace")
onready var camFactory = ctrlFactoryFloor.get_node("../camFactory")

onready var grey = Globals.infoColorModifier
onready var imageDirectory = "res://Assets/FactoryEntity"

var objConfirmMenu = preload("res://objConfirmMenu.tscn")

var entityName = ""							# i.e. "Quarry"
var entityType = ""							# "Structure" | "Connector"
var entityMasterTile = {"row":0,"col":0}	# (width,height) in pixels
var entitySize = Vector2.ZERO				# (width,height) in pixels
var entityTileSize = Vector2.ZERO			# (width,height) in number of tiles
var entityShape = [] 						# 2D array of pointerArray grid positions in shape of entity

var entityInputList = []					# List of entities we're inputting from
var entityOutputList = []					# List of entities we're outputting to

var directionInputList = []					# List of directions we're inputting from i.e. ["U","L"]
var directionOutputList = []				# List of directions we're outputting to i.e. ["D","R"]

var indexInputList = 0						# Index for the Input Lists
var indexOutputList = 0						# Index for the Output Lists

var dragDetectMode = false					# Drag Detect Mode: True when checking for finger movement
var hasDragged = false						# Drag Detect Mode: True is a finger has been dragged whilst pressing

func _ready():
	setEntitySize()

func setEntitySize(dim=[1,1]):
	entitySize = ctrlFactoryFloor.tileSize * Vector2(dim[0],dim[1])
	entityTileSize = Vector2(dim[0],dim[1])

func onPressed_Entity(_tile): # Pressed Processes for all entities
	
	# Enable drag detection
	dragDetectMode = true

func onReleased_Entity(_tile): # Pressed Processes for all entities
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return
	
	# If we're in delete mode
	if Globals.deleteStructureMode == true:
		deleteSelf() # Delete ourself
		#Globals.deleteStructureMode = false
	
	if Globals.displayInfoMode == true:
		if texInfoBar.infoNode != self:
			texInfoBar.infoNode = self
			texInfoBar.functionYet = false
		texInfoBar.updateInfo()
	
	if Globals.drawConnectorMode == "moving":
		# End the conveyor drawing
		Globals.drawConnectorMode = "ready"

func addShapeToFactory(father): # Write the father to each fatherNode entry based upon on shapeData
	# Update entityShape with the new pointerArray positions  AND  update pointerArray with entityShape areas
	for row in range( entityShape.size() ): # For every row of our shape
		for col in range( entityShape[row].size() ): # For every column in that row
			if entityShape[row][col] != 0: # If our shape is there
				# Add our pointer to every tile we occupy in pointerArray
				ctrlFactoryFloor.pointerArray[entityMasterTile["row"]+row][entityMasterTile["col"]+col].fatherNode = father

func deleteSelf():
	addShapeToFactory(null)
	queue_free() # Remove self

func addInput(entityInput,directionInput):
	if directionInput == "" or entityInput.fatherNode == self:
		return
	if not(entityInput in entityInputList+entityOutputList):
		directionInputList.append(directionInput)
		entityInputList.append(entityInput)
	print(entityName," entityInputList: ",entityInputList)

func addOutput(entityOutput,directionOutput):
	if directionOutput == "" or entityOutput.fatherNode == self:
		return
	if not(directionOutput in entityInputList+entityOutputList):
		directionOutputList.append(directionOutput)
		entityOutputList.append(entityOutput)
	print(entityName," entityOutputList: ",entityOutputList)


