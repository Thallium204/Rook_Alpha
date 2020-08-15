extends "res://classFactoryEntity.gd"

var structureName = "" 		# Name of the structure i.e. "Foundry"
var structureType = "" 		# Type of structure: processor|holder|enhancer
var internalStorage = [] 	# 
var _levelData = [] 		# List of all upgrade modifiers

var exportList = [] 		# List of connectors to export to
var exportIndex = 0			# List index of the next connector to export to

# BOOLEANS
var canBeTouched = true		# General: 			True when can be tapped | False when can't be tapped
var moveMode = false		# Move mode: 		True when moving structure | False when not moving structure
var canBePlaced = false		# Move mode: 		True when structure can be placed | False when structure is over other structures
var hasBeenPlaced = false	# move mode:		True when the building has been placed previously

func _ready():
	imageDirectory += "/Structure"
	entityType = "Structure"

func _process(_delta):
	
	# IF WE ARE MOVING THE STRUCTURE
	if moveMode == true:
		
		# Move the building in tile steps with the camera
		position[0] = stepify( camFactory.position[0] - ctrlFactoryFloor.rect_position[0] - entitySize[0]/2 , ctrlFactoryFloor.tileSize )
		position[0] = clamp(position[0] , 0 , FactorySpace.rect_size[0] - entitySize[0])
		position[1] = stepify( camFactory.position[1] - ctrlFactoryFloor.rect_position[1] - entitySize[1]/2 , ctrlFactoryFloor.tileSize )
		position[1] = clamp(position[1] , camFactory.vertical_offset , FactorySpace.rect_size[1] - entitySize[1])
		
		# Get current master tile
		# Position vector has (x,y) format, Arrays have a [row][column] format
		# Since y represents rows we need to put the y value in the first position for the Array format
		# Since x represents columns we need to put the x value in the seond position for the Array format
		entityMasterTile = [ position[1]/ctrlFactoryFloor.tileSize , position[0]/ctrlFactoryFloor.tileSize ]
		
		# If we're moving we have a Confirm Menu
		var texConfirm = get_node("tmpConfirm")
		texConfirm.rect_scale = camFactory.zoom # Scale it appropriately
		
		# If there is no space for the Confirm Menu below the structure
		texConfirm.rect_position[0] = 0 # Align the Confirm Menu with the left of the structure
		if position[1] + entitySize[1] + texConfirm.rect_size[1] + 128 > FactorySpace.rect_size[1]:
			texConfirm.rect_position[1] = -entitySize[1]*camFactory.zoom[1] # Put the Confirm Menu above the structure
		else: # If there is space for the Confirm Menu below the structure
			texConfirm.rect_position[1] = entitySize[1] # Put the Confirm Menu below the structure
		
		# Check if we can place the structure
		canBePlaced = true
		# Remove any colour tint from the YES button in the Confirm menu
		get_node("tmpConfirm/btnYes").modulate = Color(1,1,1)
		for row in range(entityTileSize[0]):
			for col in range(entityTileSize[1]):
				if ctrlFactoryFloor.pointerArray[entityMasterTile[0]+row][entityMasterTile[1]+col].fatherNode != null:
					canBePlaced = false
					get_node("tmpConfirm/btnYes").modulate = Color(1,grey,grey)

func enable_moveMode(isNew = false): # Called when we want to move this structure
	
	moveMode = true # Enable local move mode
	Globals.moveStructureMode = "moving" # Enable global move mode
	
	if isNew == false: # If we're moving an old structure
		removeSelfFromFactory() # Remove the old pointers
		camFactory.position = position+entitySize/2 # Move the camera to the middle of the structure
	
	# Add move Confirm Menu
	var newConfirm = templateNode.get_node("tmpConfirm").duplicate() # Get the Confirm Menu template
	newConfirm.get_node("labMenu").text = "Place Here?" # Set the Confirm Menu text
	newConfirm.menuResultNode = self # We give the menu our node address so it can communicate the true/false result to us (see: menuResult)
	newConfirm.menuID = "move" # We give the menu a string ID so we can interpret the true/false result (see: menuResult)
	add_child(newConfirm) # Add the Confirm Menu as a child

func disable_moveMode(placed = false): # Called when we have stopped moving this structure
	
	moveMode = false # Disable local move mode
	
	# Delete all the move-related nodes ( ConfirmMenu )
	for child in get_children(): # Check every child node
		if "Confirm" in child.name: # If the child is a tmpConfirm or tmpTileDetect
			remove_child(child) # Remove the child node
	
	if hasBeenPlaced == true: # If the building had a previous position
		Globals.moveStructureMode = "ready" # Return to ready move mode
		if placed == false: # If the building has been placed somewhere new
			position = Vector2(entityShape[0][0][1] * ctrlFactoryFloor.tileSize , entityShape[0][0][0] * ctrlFactoryFloor.tileSize)
	else:
		Globals.moveStructureMode = "off" # Disable global move mode

func menuResult(menuID,result): # Called by a menu; the menuID tells us the menu type (move|delete|etc.) | the result is the result
	
	if menuID == "move": # This is the result of the move ConfirmMenu (true|false)
		
		if result == true: # If the user tapped YES
			if canBePlaced == true: # If the structure can be placed
				disable_moveMode(true) # Disable move mode (we have placed)
				addSelfToFactory()
				hasBeenPlaced = true
			else:
				print("can't be placed!")
		else: # If the user tapped NO
			disable_moveMode(false) # Disable move mode (we haven't placed)
			if hasBeenPlaced == false: # If this was a new structure
				deleteSelf() # Destroy self

func onPressed_Structure(tile): # Pressed Processes for all structures
	
	# If we're ready to move a building
	if Globals.moveStructureMode == "ready":
		enable_moveMode()
	
	elif Globals.drawConveyorMode == "ready":
		# Begin the conveyor drawing
		Globals.drawConveyorMode = "moving"
	
	# Handle Entity
	onPressed_Entity(tile)

func onReleased_Structure(tile): # Released Processes for all structures
	
	# Handle Entity
	onReleased_Entity(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return
	
	# If we're in delete mode
	if Globals.deleteStructureMode == true:
		deleteSelf()
		#Globals.deleteStructureMode = false
	
	if Globals.moveStructureMode == "off":
		if Globals.displayInfoMode == true:
			if texInfoBar.infoNode != self:
				texInfoBar.infoNode = self
			texInfoBar.updateInfo()
	
	if Globals.drawConveyorMode == "moving":
		# End the conveyor drawing
		Globals.drawConveyorMode = "ready"







