extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
onready var texInfoBar = FactoryNode.get_node("SideBarNode/texInfoBar")
onready var FactorySpace = ctrlFactoryFloor.get_node("../FactorySpace")
onready var camFactory = ctrlFactoryFloor.get_node("../camFactory")

onready var grey = Globals.infoColorModifier
onready var imageDirectory = "res://Assets/FactoryEntity"

var entityType = ""
var entityMasterTile = []			# (width,height) in pixels
var entitySize = Vector2.ZERO		# (width,height) in pixels
var entityTileSize = Vector2.ZERO	# (width,height) in number of tiles
var entityShape = [] 				# 2D array of pointerArray grid positions in shape of entity

var dragDetectMode = false			# Drag Detect Mode: True when checking for finger movement
var hasDragged = false				# Drag Detect Mode: True is a finger has been dragged whilst pressing

func _ready():
	setEntitySize()

func setEntitySize(dim=[1,1]):
	entitySize = ctrlFactoryFloor.tileSize * Vector2(dim[0],dim[1])
	entityTileSize = Vector2(dim[0],dim[1])

func onPressed_Entity(tile): # Pressed Processes for all entities
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return

func onReleased_Entity(tile): # Pressed Processes for all entities
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return

func addSelfToFactory(): # Called when we have placed this structure
	# Update entityShape with the new pointerArray positions  AND  update pointerArray with entityShape areas
	for row in range( entityShape.size() ): # For every row of our shape
		for col in range( entityShape[row].size() ): # For every column in that row
			if entityShape[row][col] != null: # If our shape is there
				entityShape[row][col] = [0,0] # Reset the entityShape references
				entityShape[row][col][0] = entityMasterTile[0] + row # Update the entityShape row reference
				entityShape[row][col][1] = entityMasterTile[1] + col # Update the entityShape column reference
				# Add our pointer to every tile we occupy in pointerArray
				ctrlFactoryFloor.pointerArray[ entityShape[row][col][0] ][ entityShape[row][col][1] ].fatherNode = self

func removeSelfFromFactory():
	# Remove pointers from the pointerArray
	for row in entityShape:
		for col in row:
			if ctrlFactoryFloor.pointerArray[col[0]][col[1]].fatherNode == self:
				ctrlFactoryFloor.pointerArray[col[0]][col[1]].fatherNode = null

func deleteSelf():
	removeSelfFromFactory()
	queue_free() # Remove self




