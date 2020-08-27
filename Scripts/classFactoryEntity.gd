extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
onready var FactorySpace = ctrlFactoryFloor.get_node("../texBackground")
onready var camFactory = ctrlFactoryFloor.get_node("../camFactory")

onready var texInfoBar = FactoryNode.get_node("SideBarNode/texInfoBar")
onready var ResourceBarNode = FactoryNode.get_node("ResourceBarNode")

onready var grey = Globals.infoColorModifier
onready var imageDirectory = "res://Assets/FactoryEntity"

var objConfirmMenu = preload("res://Scenes/FactoryScene/objConfirmMenu.tscn")

var entityName = ""							# i.e. "Quarry"
var entityType = ""							# "Structure" | "Connector"
var entityMasterTile = {"row":0,"col":0}	# (width,height) in pixels
var entitySize = Vector2.ZERO				# (width,height) in pixels
var entityTileSize = Vector2.ZERO			# (width,height) in number of tiles
var entityShape = [] 						# 2D array of pointerArray grid positions in shape of entity

var entityInputList = []					# List of objFactoryTile's we're inputting from
var entityOutputList = []					# List of objFactoryTile's we're outputting to
var directionInputList = []					# List of directions we're inputting from i.e. ["U","L"]
var directionOutputList = []				# List of directions we're outputting to i.e. ["D","R"]
var indexInputList = 0						# Index for the Input Lists
var indexOutputList = 0						# Index for the Output Lists
var pulsed = false

func configure_Entity(entityData):
	
	entityName = entityData["nameID"]
	entityTileSize = Vector2(entityShape[0].size(),entityShape.size())
	entitySize = ctrlFactoryFloor.tileSize * entityTileSize

func onPressed_Entity(_tile): # Pressed Processes for all entities
	
	print()
	print(entityInputList)
	print(directionInputList)
	print(entityOutputList)
	print(directionOutputList)
	print(z_index)
	
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
	
	# Set appropriate z-value
	if entityType == "Structure":
		z_index = entityMasterTile["row"] + 100
	elif entityType == "Connector":
		z_index = 1

func deleteSelf():
	removeInputOutputRefs()
	addShapeToFactory(null)
	queue_free() # Remove self

func removeInputOutputRefs():
	
	for inputTile in entityInputList: # For each objFactoryTile in our entityInputList
		if inputTile.fatherNode != null:
			var target_entityOutputList = inputTile.fatherNode.entityOutputList
			var target_directionOutputList = inputTile.fatherNode.directionOutputList
			var outputIndex = 0
			while outputIndex < target_entityOutputList.size(): # For each output in the fatherNode
				if target_entityOutputList[outputIndex].fatherNode == self:
					target_entityOutputList.remove(outputIndex)
					target_directionOutputList.remove(outputIndex)
					inputTile.fatherNode.updateUI()
				outputIndex += 1
	
	for outputTile in entityOutputList:
		if outputTile.fatherNode != null:
			var target_entityInputList = outputTile.fatherNode.entityInputList
			var target_directionInputList = outputTile.fatherNode.directionInputList
			var inputIndex = 0
			while inputIndex < target_entityInputList.size():
				if target_entityInputList[inputIndex].fatherNode == self:
					target_entityInputList.remove(inputIndex)
					target_directionInputList.remove(inputIndex)
					outputTile.fatherNode.updateUI()
				inputIndex += 1
	
	entityInputList = []					# List of objFactoryTile's we're inputting from
	entityOutputList = []					# List of objFactoryTile's we're outputting to
	directionInputList = []					# List of directions we're inputting from i.e. ["U","L"]
	directionOutputList = []				# List of directions we're outputting to i.e. ["D","R"]
	indexInputList = 0						# Index for the Input Lists
	indexOutputList = 0						# Index for the Output Lists

func addInput(entityInput,directionInput):
	if directionInput == "" or entityInput.fatherNode == self:
		return
	if not(entityInput in entityInputList+entityOutputList):
		directionInputList.append(directionInput)
		entityInputList.append(entityInput)

func addOutput(entityOutput,directionOutput):
	if directionOutput == "" or entityOutput.fatherNode == self:
		return
	if not(entityOutput in entityInputList+entityOutputList):
		directionOutputList.append(directionOutput)
		entityOutputList.append(entityOutput)

func sendPulse(pulseList):
	
	if pulsed == true:
		return pulseList
	
	pulsed = true
	
	if entityType == "Structure" and not(self in pulseList):
		pulseList.append(self)
		print("found ",self.name)
		pulsed = false
	else:
		for inputTile in entityInputList:
			pulseList = inputTile.fatherNode.sendPulse(pulseList)
	
	pulsed = false
	
	return pulseList




