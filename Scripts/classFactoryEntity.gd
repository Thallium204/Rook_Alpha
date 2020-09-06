extends Node2D

onready var Menus = get_tree().get_root().get_node("Game/Menus")
onready var FactoryNode = Menus.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
onready var FactorySpace = ctrlFactoryFloor.get_node("../texBackground")
onready var camFactory = ctrlFactoryFloor.get_node("../camFactory")

onready var texInfoBar = FactoryNode.get_node("SideBarNode/texInfoBar")
onready var ResourceBarNode = FactoryNode.get_node("ResourceBarNode")

onready var grey = Globals.infoColorModifier
onready var imageDirectory = "res://Assets/FactoryEntity"

var objConfirmMenu = preload("res://Scenes/FactoryScene/objConfirmMenu.tscn")

var rng = RandomNumberGenerator.new()

var entityName = ""							# i.e. "Quarry"
var entityType = ""							# "Structure" | "Connector"
var entityClass = ""						# "Processor" | "Conveyor" | etc...
var entityMasterTile = {"row":0,"col":0}	# (width,height) in pixels
var entitySize = Vector2.ZERO				# (width,height) in pixels
var entityTileSize = Vector2.ZERO			# (width,height) in number of tiles
var entityShape = [] 						# 2D array of pointerArray grid positions in shape of entity

var networkIDs = []							# List of networks we're a part of
var ioList = []								# List of {tile":ioTile,"dire":"X","self":selfTile}'s
var ioIndex = {"input":0,"output":0}		# Indexes for the ioPairList
var adjacentTileList = []					# List of [ioTile,ioDire]'s of adjacent tiles
var pulsed = false
var pulseList = []

var dirConv = { Vector2(-1,0):"U", Vector2(0,1):"R", Vector2(1,0):"D", Vector2(0,-1):"L" }

func _ready():
	rng.randomize()

func setAdjacencyTileList():
	adjacentTileList = []
	for rowIndex in range(entityShape.size()):
		for colIndex in range(entityShape[rowIndex].size()):
			if entityShape[rowIndex][colIndex] == 1: # If this tile is a part of our shape
				var mainRC = [entityMasterTile["row"]+rowIndex,entityMasterTile["col"]+colIndex]
				var selfTile = ctrlFactoryFloor.pointerArray[mainRC[0]][mainRC[1]]
				for dir in dirConv:
					var adjacentTile = ctrlFactoryFloor.pointerArray[mainRC[0]+dir[0]][mainRC[1]+dir[1]]
					if adjacentTile.fatherNode != self: # If the adjacent tile is not us
						# It must be adjacent to us
						if not(adjacentTile in adjacentTileList): # If we have not already recorded it
							adjacentTileList.append({"tile":adjacentTile,"vector":dir,"self":selfTile})

func configure_Entity(entityData):
	
	entityName = entityData["nameID"]
	entityTileSize = Vector2(entityShape[0].size(),entityShape.size())
	entitySize = ctrlFactoryFloor.tileSize * entityTileSize
	Inventory.addEntityRef(self)

func addNetworkID(newID):
	if not(newID in networkIDs):
		networkIDs.append(newID)

func removeNetworkID(oldID):
	networkIDs.erase(oldID)

func removeNetworkRefs():
	Networks.removeFromNetwork(self,networkIDs.duplicate())

func addIOTile(io):
	if not(io in ioList):
		ioList.append(io)

func removeIOTile(io):
	ioList.erase(io)

func deleteSelf(isNew=false):
	Inventory.removeEntityRef(self)
	if not isNew:
		removeInputOutputRefs()
		removeNetworkRefs()
		addShapeToFactory(null)
	queue_free() # Remove self

func onPressed_Entity(_tile): # Pressed Processes for all entities
	
	pass

func onReleased_Entity(_tile): # Pressed Processes for all entities
	
	# If we're in delete mode
	if Globals.deleteStructureMode == true:
		deleteSelf() # Delete ourself
		#Globals.deleteStructureMode = false
	
	if Globals.displayInfoMode == true and entityType == "Structure":
		if texInfoBar.infoNode != self:
			texInfoBar.infoNode = self
			texInfoBar.functionYet = false
		texInfoBar.updateInfo()

func addShapeToFactory(father): # Write the father to each fatherNode entry based upon on shapeData
	# Update entityShape with the new pointerArray positions  AND  update pointerArray with entityShape areas
	for row in range( entityShape.size() ): # For every row of our shape
		for col in range( entityShape[row].size() ): # For every column in that row
			if entityShape[row][col] != 0: # If our shape is there
				# Add our pointer to every tile we occupy in pointerArray
				ctrlFactoryFloor.pointerArray[entityMasterTile["row"]+row][entityMasterTile["col"]+col].setFatherNode(father)
	
	setAdjacencyTileList()
	
	# Set appropriate z-value
	if entityType == "Structure":
		z_index = entityMasterTile["row"] + 100
	elif entityType == "Connector":
		z_index = 1

func removeInputOutputRefs():
	
	for io in ioList: # For each objFactoryTile in our ioTileList
		if io["tile"].fatherNode != null: # If this is the tile of an entity
			var target_ioList = io["tile"].fatherNode.ioList
			for target_io in target_ioList: # For each output in the fatherNode
				if target_io["tile"].fatherNode == self:
					target_ioList.erase(target_io) # Remove ourself from their ioList
					target_io["tile"].fatherNode.updateUI() # Update ourselves
		io["tile"].fatherNode.updateUI() # Update them
	
	ioList = []
	ioIndex = {"input":0,"output":0}

func sendPulse(entityList):
	
	if pulsed == false:
		pulsed = true
		entityList.append(self)
		if entityType == "Connector":
			for io in ioList:
				if io["tile"].fatherNode.pulsed == false:
					io["tile"].fatherNode.sendPulse(entityList)
		elif entityType == "Structure":
			pulsed = false
	
	return entityList




