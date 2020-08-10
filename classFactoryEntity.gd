extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
onready var texInfoBar = FactoryNode.get_node("SideBarNode/texInfoBar")
onready var FactorySpace = ctrlFactoryFloor.get_node("../FactorySpace")
onready var camFactory = ctrlFactoryFloor.get_node("../camFactory")

onready var grey = Globals.infoColorModifier

var structureName = "" 		# Name of the structure i.e. "Foundry"
var structureType = "" 		# Type of structure: Building|Storage
var internalStorage = [] 	# For Builings: [inputStorage,outputStorage] | For Storage: [ioStorage]
var masterTile = null		# top-left most tile [ row , col ]
var shapeData = [] 			# 2D array of FactoryFloor grid positions in shape of structure
var _levelData = [] 		# List of all upgrade modifiers

var toList = [] 			# List of pointers of all extraction conveyors
var fromList = []			# List of pointers of all insertion conveyors

# BOOLEANS
var isProcessing = false	# General:   		True when building is processing | False when building is not processing
var autoCraft = false		# General: 			True when always trying to process | False when not always trying to process
var canBeTouched = true		# General: 			True when can be tapped | False when can't be tapped
var moveMode = false		# Move mode: 		True when moving structure | False when not moving structure
var canBePlaced = false		# Move mode: 		True when structure can be placed | False when structure is over other structures
var hasBeenPlaced = false	# move mode:		True when the building has been placed previously
var dragDetectMode = false	# Drag Detect Mode: True when checking for finger movement whilst pressing child button
var hasDragged = false		# Drag Detect Mode: True is a finger has been dragged whilst pressing a chi8ld button



func _process(_delta):
	
	# IF WE ARE MOVING THE STRUCTURE
	if moveMode == true:
		
		# Show alpha of the TileDetects
		get_node("tmpShape").modulate = Color(1,1,1,0.5)
		
		# Move the building in tile steps with the camera
		rect_position[0] = stepify( camFactory.position[0] - ctrlFactoryFloor.rect_position[0] - rect_size[0]/2 , ctrlFactoryFloor.tileSize )
		rect_position[0] = clamp(rect_position[0] , 0 , FactorySpace.rect_size[0] - rect_size[0])
		rect_position[1] = stepify( camFactory.position[1] - ctrlFactoryFloor.rect_position[1] - rect_size[1]/2 , ctrlFactoryFloor.tileSize )
		rect_position[1] = clamp(rect_position[1] , camFactory.vertical_offset , FactorySpace.rect_size[1] - rect_size[1])
		
		# Get current master tile
		# Position vector has (x,y) format, Arrays have a [row][column] format
		# Since y represents rows we need to put the y value in the first position for the Array format
		# Since x represents columns we need to put the x value in the seond position for the Array format
		masterTile = [ rect_position[1]/ctrlFactoryFloor.tileSize , rect_position[0]/ctrlFactoryFloor.tileSize ]
		
		# If we're moving we have a Confirm Menu
		var texConfirm = get_node("tmpConfirm")
		texConfirm.rect_scale = camFactory.zoom # Scale it appropriately
		
		# If there is no space for the Confirm Menu below the structure
		texConfirm.rect_position[0] = 0 # Align the Confirm Menu with the left of the structure
		if rect_position[1] + rect_size[1] + texConfirm.rect_size[1] + 128 > FactorySpace.rect_size[1]:
			texConfirm.rect_position[1] = -256*camFactory.zoom[1] # Put the Confirm Menu above the structure
		else: # If there is space for the Confirm Menu below the structure
			texConfirm.rect_position[1] = rect_size[1] # Put the Confirm Menu below the structure
		
		# Check if we can place the structure
		canBePlaced = true # Assume we can place the structure
		get_node("tmpConfirm/btnYes").modulate = Color(1,1,1) # Remove any colour tint from the YES button in the Confirm menu
		for tileNode in get_node("tmpShape").get_children(): # Check every tile child node
			if tileNode.check_isTileFree(masterTile) == false: # If the tile says it's above a structure
				tileNode.modulate = Color(1,grey,grey)
				canBePlaced = false # We can't place the structure
				get_node("tmpConfirm/btnYes").modulate = Color(grey,grey,grey) # Colour the YES button in the Confirm menu grey
			else:
				tileNode.modulate = Color(grey,1,grey)
	else:
		for tileNode in get_node("tmpShape").get_children(): # Check every tile child node
			tileNode.modulate = Color(1,1,1)
		get_node("tmpShape").modulate = Color(grey,grey,grey,0.2)

func enable_moveMode(initial = false): # Called when we want to move this structure
	
	moveMode = true # Enable local move mode
	Globals.moveStructureMode = "moving" # Enable global move mode
	
	if initial == false: # If the structure has just been created
		removePointersFromArray()
		camFactory.position = rect_position+rect_size/2
	
	# Add move Confirm Menu
	var newConfirm = templateNode.get_node("tmpConfirm").duplicate() # Get the Confirm Menu template
	newConfirm.get_node("labMenu").text = "Place Here?" # Set the Confirm Menu text
	newConfirm.menuResultNode = self # We give the menu our node address so it can communicate the true/false result to us (see: menuResult)
	newConfirm.menuID = "move" # We give the menu a string ID so we can interpret the true/false result (see: menuResult)
	add_child(newConfirm) # Add the Confirm Menu as a child

func disable_moveMode(placed = false): # Called when we have stopped moving this structure
	
	moveMode = false # Disable local move mode
	
	# Delete all the move-related nodes ( ConfirmMenu | TileDetect )
	for child in get_children(): # Check every child node
		if "Confirm" in child.name or "Tile" in child.name: # If the child is a tmpConfirm or tmpTileDetect
			remove_child(child) # Remove the child node
	
	if hasBeenPlaced == true: # If the building had a previous position
		Globals.moveStructureMode = "ready" # Return to ready move mode
		if placed == false: # If the building has been placed somewhere new
			rect_position = Vector2(shapeData[0][0][1] * ctrlFactoryFloor.tileSize , shapeData[0][0][0] * ctrlFactoryFloor.tileSize)
	else:
		Globals.moveStructureMode = "off" # Disable global move mode

func addSelfToFactory(): # Called when we have placed this structure
	# Update the shape data with the new grid positions  AND  update the pointerArray with this objects pointers
	for row in range( shapeData.size() ): # For every row of our shape
		for col in range( shapeData[row].size() ): # For every column in that row
			if shapeData[row][col] != null: # If our shape is there
				shapeData[row][col] = [0,0] # Reset the shapeData references
				shapeData[row][col][0] = masterTile[0] + row # Update the shapeData row reference
				shapeData[row][col][1] = masterTile[1] + col # Update the shapeData column reference
				# Add our pointer to every tile we occupy in pointerArray
				ctrlFactoryFloor.pointerArray[ shapeData[row][col][0] ][ shapeData[row][col][1] ] = self
	hasBeenPlaced = true

func menuResult(menuID,result): # Called by a menu; the menuID tells us the menu type (move|delete|etc.) | the result is the result
	
	if menuID == "move": # This is the result of the move ConfirmMenu (true|false)
		
		if result == true: # If the user tapped YES
			if canBePlaced == true: # Check if the structure can be placed
				disable_moveMode(true)
				addSelfToFactory()
			else:
				print("can't be placed!")
		else: # If the user tapped NO
			disable_moveMode(false)
			if hasBeenPlaced == false:
				get_parent().remove_child(self) # Destroy self

func onStructure_Pressed_General(_tile): # Called when a tile button is pressed
	
	# If we're ready to move a building
	if Globals.moveStructureMode == "ready":
		enable_moveMode()

func onStructure_Released_General(_tile): # Called when a tile button is released
	
	# If we're in delete mode
	if Globals.deleteStructureMode == true:
		removeSelf()
		Globals.deleteStructureMode = false
	
	if Globals.moveStructureMode == "off":
		if Globals.displayInfoMode == true:
			if texInfoBar.infoNode != self:
				texInfoBar.infoNode = self
			texInfoBar.updateInfo()

func removeSelf():
	removePointersFromArray()
	ctrlFactoryFloor.remove_child(self) # Remove self

func removePointersFromArray():
	# Remove pointers from the pointerArray
	for row in shapeData:
		for col in row:
			if col != null:
				ctrlFactoryFloor.pointerArray[col[0]][col[1]] = null
	





