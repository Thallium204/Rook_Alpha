extends "res://classFactoryEntity.gd"

var structureType = ""
var _levelData = [] 		# List of all upgrade modifiers
var last_entityMasterTile = null

var outputRate = 0.5
var deltaOutput = 0.0

# BOOLEANS
var moveMode = false		# Move mode: 		True when moving structure | False when not moving structure
var canBePlaced = false		# Move mode: 		True when structure can be placed | False when structure is over other structures

func _ready():
	imageDirectory += "/Structure"
	entityType = "Structure"

func _process(_delta):
	
	if moveMode == true:
		process_moveMode()

func process_moveMode(): # Called through process when in moveMode
	
	# Move the building in tile steps with the camera
	position[0] = stepify( camFactory.position[0] - ctrlFactoryFloor.rect_position[0] - entitySize[0]/2 , ctrlFactoryFloor.tileSize )
	position[0] = clamp(position[0] , 0 , FactorySpace.rect_size[0] - entitySize[0])
	position[1] = stepify( camFactory.position[1] - ctrlFactoryFloor.rect_position[1] - entitySize[1]/2 , ctrlFactoryFloor.tileSize )
	position[1] = clamp(position[1] , camFactory.vertical_offset , FactorySpace.rect_size[1] - entitySize[1])
	
	# Get current master tile
	# Position vector has (x,y) format, Arrays have a [row][column] format
	# Since y represents rows we need to put the y value in the first position for the Array format
	# Since x represents columns we need to put the x value in the seond position for the Array format
	entityMasterTile["row"] = position[1]/ctrlFactoryFloor.tileSize
	entityMasterTile["col"] = position[0]/ctrlFactoryFloor.tileSize
	
	# Update the Confirm Menu position
	get_node("objConfirmMenu").updatePosition(FactorySpace.rect_size,entitySize,camFactory.zoom[1])
	
	# Check if we can place the structure
	canBePlaced = true
	# Remove any colour tint from the YES button in the Confirm menu
	get_node("objConfirmMenu/btnYes").modulate = Color(1,1,1)
	for row in range(entityTileSize[0]):
		for col in range(entityTileSize[1]):
			if ctrlFactoryFloor.pointerArray[entityMasterTile["row"]+row][entityMasterTile["col"]+col].fatherNode != null:
				canBePlaced = false
				get_node("objConfirmMenu/btnYes").modulate = Color(1,grey,grey)

func enable_moveMode(isNew = false): # Called when we want to move this structure
	
	moveMode = true # Enable local move mode
	Globals.moveStructureMode = "moving" # Enable global move mode
	
	# Add move Confirm Menu
	var newConfirmMenu = objConfirmMenu.instance() # Get the Confirm Menu template
	newConfirmMenu.get_node("labMenu").text = "Place Here?" # Set the Confirm Menu text
	newConfirmMenu.menuResultNode = self # We give the menu our node address so it can communicate the true/false result to us (see: menuResult)
	newConfirmMenu.menuID = "move" # We give the menu a string ID so we can interpret the true/false result (see: menuResult)
	add_child(newConfirmMenu) # Add the Confirm Menu as a child
	
	if isNew == false: # If we're moving an old structure
		camFactory.position = position+entitySize/2 # Move the camera to the middle of the structure
		addShapeToFactory(null) # Remove old shape

func disable_moveMode(placed = false): # Called when we have stopped moving this structure
	
	moveMode = false # Disable local move mode
	
	# Delete all the move-related nodes ( ConfirmMenu )
	get_node("objConfirmMenu").queue_free()
	
	# Decide moveStructureMode behaviour
	if last_entityMasterTile == null: # If the structure was new
		Globals.moveStructureMode = "off" # Disable  move mode
	else: # If the structure was old
		Globals.moveStructureMode = "ready" # Return to ready global move mode
	
	if placed == false: # If we pressed cancel
		
		if last_entityMasterTile == null: # If we're a new structure
			queue_free() # Destroy self
			return
		else: # If we're an old structure
			entityMasterTile = last_entityMasterTile.duplicate(true) # Reset masterTile
			# Return to previous position
			position = ctrlFactoryFloor.tileSize * Vector2(last_entityMasterTile["col"] , last_entityMasterTile["row"])
		
	else: # If we pressed confirm
		
		last_entityMasterTile = entityMasterTile.duplicate(true) # Update last_masterTile
	
	addShapeToFactory(self) # Add ourself to the pointerArray

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
	
	# Handle Entity
	onReleased_Entity(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return







