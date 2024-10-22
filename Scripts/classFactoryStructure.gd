extends "res://Scripts/classFactoryEntity.gd"

var last_entityMasterTile = null
var waitingOnWorker = false

var ioMode = "retrieve"		# "retrieve" | "extract"

# BOOLEANS
var moveMode = false		# Move mode: 		True when moving structure | False when not moving structure
var canBePlaced = false		# Move mode: 		True when structure can be placed | False when structure is over other structures

func _ready():
	imageDirectory += "/Structure"
	entityType = "Structure"
	add_to_group("Structure")

func generateRequest(requestType):
	
	waitingOnWorker = true
	
	if requestType == "pull":
		return { "sender":self , "type":requestType }
	elif requestType == "process":
		return {}

func sendRequest(_request):
	pass

func updateNetwork():
	for adj in adjacentTileList: # Scan our surroundings
		# ioPair = [ioTile,ioDire (of the adjacent tile)]
		if adj["tile"].fatherNode != null: # Scan for entities only
			var checkEntity = adj["tile"].fatherNode
			var rowDiff = adj["tile"].entityTile["row"] - adj["vector"][0]
			var colDiff = adj["tile"].entityTile["col"] - adj["vector"][1]
			var selfTile = ctrlFactoryFloor.pointerArray[rowDiff][colDiff]
			ioList.append( { "tile":adj["tile"] , "dire":dirConv[adj["vector"]] , "self":selfTile } )
			checkEntity.ioList.append( { "tile":selfTile , "dire":dirConv[-adj["vector"]] , "self":adj["tile"]} )
			if checkEntity.entityType == "Structure":
				Networks.instanceNetwork([self,checkEntity],"Structure")
			elif checkEntity.entityType == "Connector":
				Networks.addToNetwork(self,checkEntity.networkIDs[0])
			checkEntity.updateUI()
			selfTile.fatherNode.updateUI()

func deleteFromNetwork():
	for adj in adjacentTileList: # Scan our surroundings
		if adj["tile"].fatherNode != null: # Scan for entities only
			var checkEntity = adj["tile"].fatherNode
			if checkEntity.entityType == "Structure":
				Networks.deleteNetworks(networkIDs,true)

func extractResource(outputBuffer):
	
	# Find all potential receivers
	var receivers = []
	for netID in networkIDs: # Go through our networks
		var network = Networks.networkArray[netID]
		#print(netID," network: ",network["type"]," buffer: ",outputBuffer)
		if network["type"] != "Structure":
			#print(network["type"]," != ",typeDict[outputBuffer["type"]])
			if network["type"] != typeDict[outputBuffer["type"]]: # If this network doesn't carry our resource
				continue # skip it
		for structure in network["Structure"]: # Go through the potential structures
			if structure == self:
				continue
			for inputBuffer in structure.getInputBuffers():
				if inputBuffer["name"] == outputBuffer["name"] or inputBuffer["name"] == "":
					if inputBuffer["potential"] < inputBuffer["max"]: # If it has room
						receivers.append({"entity":structure,"buffer":inputBuffer,"netID":netID})
	
	if receivers.empty():
		return
	
	# Deduct resource and tell target it's receiving our resource
	ioIndex["output"] = (ioIndex["output"]+1)%receivers.size()
	var target = receivers[ioIndex["output"]]
	#print(target["entity"].name)
	target["buffer"]["potential"] += 1 # Tell the target it has our resource on the way
	if target["entity"].entityClass == "Holder": # If the target is a holder
		target["buffer"]["name"] = outputBuffer["name"] # Overwrite it's resource name
	outputBuffer["current"] -= 1 # Deduct our resource
	if entityClass == "Holder": # If we're a holder
		outputBuffer["potential"] -= 1 # Deduct our internalStorage potential
	
	# If this is a neighbouring structure
	if Networks.networkArray[receivers[ioIndex["output"]]["netID"]]["type"] == "Structure":
		target["buffer"]["current"] += 1 # Add the resource immediately
	
	# If this is a conveyor path
	elif Networks.networkArray[receivers[ioIndex["output"]]["netID"]]["type"] == "Conveyor":
		var tilePath = Networks.networkArray[target["netID"]]["tilePaths"][self][target["entity"]] # Get travel path
		ctrlFactoryFloor.spawnResource(outputBuffer["name"],tilePath,target["buffer"])
	
	# If this is a pipe path
	elif Networks.networkArray[receivers[ioIndex["output"]]["netID"]]["type"] == "Pipe":
		target["buffer"]["current"] += 1 # Add the resource immediately
	
	# If this is a cable path
	elif Networks.networkArray[receivers[ioIndex["output"]]["netID"]]["type"] == "Cable":
		target["buffer"]["current"] += 1 # Add the resource immediately

func retrieveResource(inputBuffer):
	# Find all potential receivers
	var extractors = []
	for netID in networkIDs: # Go through our networks
		var network = Networks.networkArray[netID]
		#print(netID," network: ",network["type"]," buffer: ",outputBuffer)
		if network["type"] != "Structure":
			#print(network["type"]," != ",typeDict[outputBuffer["type"]])
			if network["type"] != typeDict[inputBuffer["type"]]: # If this network doesn't carry our resource
				continue # skip it
		for structure in network["Structure"]: # Go through the potential structures
			if structure == self:
				continue
			for outputBuffer in structure.getOutputBuffers():
				if outputBuffer["name"] ==  inputBuffer["name"] or inputBuffer["name"] == "":
					if outputBuffer["current"] > 0: # If we have room
						extractors.append({"entity":structure,"buffer":outputBuffer,"netID":netID})
	
	if extractors.empty():
		return
	
	# Deduct resource and tell target it's receiving our resource
	ioIndex["input"] = (ioIndex["input"]+1)%extractors.size()
	var target = extractors[ioIndex["input"]]
	#print(target["entity"].name)
	inputBuffer["potential"] += 1 # Tell ourself the resource is on the way
	if entityClass == "Holder": # If we're a holder
		inputBuffer["name"] = target["buffer"]["name"] # Overwrite our resource name
	target["buffer"]["current"] -= 1 # Deduct their resource
	if target["entity"].entityClass == "Holder": # If we're a holder
		target["buffer"]["potential"] -= 1 # Deduct their internalStorage potential
	
	# If this is a neighbouring structure
	if Networks.networkArray[extractors[ioIndex["input"]]["netID"]]["type"] == "Structure":
		inputBuffer["current"] += 1 # Add the resource immediately
	
	# If this is a conveyor path
	elif Networks.networkArray[extractors[ioIndex["input"]]["netID"]]["type"] == "Conveyor":
		var tilePath = Networks.networkArray[target["netID"]]["tilePaths"][target["entity"]][self] # Get travel path
		ctrlFactoryFloor.spawnResource(target["buffer"]["name"],tilePath,inputBuffer)
	
	# If this is a pipe path
	elif Networks.networkArray[extractors[ioIndex["input"]]["netID"]]["type"] == "Pipe":
		inputBuffer["current"] += 1 # Add the resource immediately
	
	# If this is a cable path
	elif Networks.networkArray[extractors[ioIndex["input"]]["netID"]]["type"] == "Cable":
		inputBuffer["current"] += 1 # Add the resource immediately

func _process(_delta):
	
	if moveMode == true:
		process_moveMode()
	
	if texInfoBar.infoNode == self and Globals.displayInfoMode == true:
		$texSelect.modulate = Color(1,1,1,1)
	else:
		$texSelect.modulate = Color(1,1,1,0)
	
	if ioMode == "retrieve":
		
		for inputBuffer in call("getInputBuffers"):
			if inputBuffer["current"] < inputBuffer["max"]:
				retrieveResource(inputBuffer)
		
	elif ioMode == "extract":
		
		for outputBuffer in call("getOutputBuffers"):
			if outputBuffer["current"] > 0:
				extractResource(outputBuffer)

func configure_Structure(structureData):
	
	entityShape = structureData["shapeData"]
	
	configure_Entity(structureData)
	
	$texSelect.rect_size = entitySize

func process_moveMode(): # Called through process when in moveMode
	
	# Move the building in tile steps with the camera
	position[0] = stepify( camFactory.position[0] - ctrlFactoryFloor.rect_position[0] - entitySize[0]/2 , ctrlFactoryFloor.tileSize )
	position[0] = clamp(position[0] , 0 , FactorySpace.rect_size[0] - entitySize[0])
	position[1] = stepify( camFactory.position[1] - ctrlFactoryFloor.rect_position[1] - entitySize[1]/2 , ctrlFactoryFloor.tileSize )
	position[1] = clamp(position[1] , camFactory.vertical_offset , FactorySpace.rect_size[1] - entitySize[1])
	
	# Update entityMasterTile
	entityMasterTile["row"] = position[1]/ctrlFactoryFloor.tileSize
	entityMasterTile["col"] = position[0]/ctrlFactoryFloor.tileSize
	
	# Update the Confirm Menu position
	get_node("objConfirmMenu").updatePosition(FactorySpace.rect_size,entitySize,camFactory.zoom[1])
	
	# Check if we can place the structure
	canBePlaced = true
	# Remove any colour tint from the YES button in the Confirm menu
	get_node("objConfirmMenu/btnYes").modulate = Color(1,1,1)
	for row in range(entityTileSize[1]):
		for col in range(entityTileSize[0]):
			if ctrlFactoryFloor.pointerArray[entityMasterTile["row"]+row][entityMasterTile["col"]+col].fatherNode != null:
				canBePlaced = false
				get_node("objConfirmMenu/btnYes").modulate = Color(grey,grey,grey)

func enable_moveMode(isNew = false): # Called when we want to move this structure
	
	moveMode = true # Enable local move mode
	Globals.moveStructureMode = "moving" # Enable global move mode
	
	# Visual Changes
	z_index = 4096
	$sprStructure.self_modulate = Color(1,1,1,0.8)
	$texSelect.modulate = Color(1,1,1,1)
	
	# Add move Confirm Menu
	var newConfirmMenu = objConfirmMenu.instance() # Get the Confirm Menu template
	newConfirmMenu.get_node("labMenu").text = "Place Here?" # Set the Confirm Menu text
	newConfirmMenu.menuResultNode = self # We give the menu our node address so it can communicate the true/false result to us (see: menuResult)
	newConfirmMenu.menuID = "move" # We give the menu a string ID so we can interpret the true/false result (see: menuResult)
	add_child(newConfirmMenu) # Add the Confirm Menu as a child
	
	if isNew == false: # If we're moving an old structure
		camFactory.position = position+entitySize/2 # Move the camera to the middle of the structure
		removeInputOutputRefs()
		addShapeToFactory(null) # Remove old shape
	
	get_tree().call_group("sideBar","updateUI")

func disable_moveMode(placed = false): # Called when we have stopped moving this structure
	
	get_tree().call_group("bar","updateUI")
	
	z_index = 0
	$sprStructure.self_modulate = Color(1,1,1,1)
	$texSelect.modulate = Color(1,1,1,0)
	
	var isNew = false
	if last_entityMasterTile == null:
		isNew = true
	
	if placed == false: # If we pressed cancel
		
		if isNew == true: # If we're a new structure
			deleteSelf(true)
		else: # If we're an old structure
			entityMasterTile = last_entityMasterTile.duplicate(true) # Reset masterTile
			# Return to previous position
			position = ctrlFactoryFloor.tileSize * Vector2(last_entityMasterTile["col"] , last_entityMasterTile["row"])
			addShapeToFactory(self)
			updateNetwork()
		
	else: # If we pressed confirm
		
		if canBePlaced == true: # If we can place it
			last_entityMasterTile = entityMasterTile.duplicate(true) # Update last_masterTile
			addShapeToFactory(self)
			updateNetwork()
		else:
			return
	
	moveMode = false # Disable local move mode
	
	# Delete all the move-related nodes ( ConfirmMenu )
	get_node("objConfirmMenu").queue_free()
	
	# Decide moveStructureMode behaviour
	if isNew == true: # If the structure was new
		Globals.moveStructureMode = "off" # Disable  move mode
	else: # If the structure was old
		Globals.moveStructureMode = "ready" # Return to ready global move mode

func menuResult(menuID,result): # Called by a menu; the menuID tells us the menu type (move|delete|etc) | the result is the result
	
	if menuID == "move": # This is the result of the move ConfirmMenu (true|false)
		disable_moveMode(result) # Disable move mode (have we placed?)

func onPressed_Structure(tile): # Pressed Processes for all structures
	
	# Handle Entity
	onPressed_Entity(tile)
	
	# If we're ready to move a building
	if Globals.moveStructureMode == "ready":
		enable_moveMode()

func onReleased_Structure(tile): # Released Processes for all structures
	
	if Globals.deleteStructureMode == true:
		deleteFromNetwork()
	
	# Handle Entity
	onReleased_Entity(tile)







