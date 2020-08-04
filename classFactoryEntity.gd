extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var ctrlFactoryFloor = Globals.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/FactorySceneNode/ctrlFactoryFloor")
onready var FactorySpace = ctrlFactoryFloor.get_node("../FactorySpace")
onready var camFactory = ctrlFactoryFloor.get_node("../camFactory")

onready var grey = Globals.infoColorModifier

var structureName = "" 		# Name of the structure i.e. "Foundry"
var structureType = "" 		# Type of structure: Building|Storage
var internalStorage = [] 	# For Builings: [inputStorage,outputStorage] | For Storage: [ioStorage]
var masterTile = 0			# top-right most tile [ row , col ]
var shapeData = [] 			# 2D array of FactoryFloor grid positions in shape of structure
var _levelData = [] 		# List of all upgrade modifiers

var processTime = 0 		# Time taken to complete a single process
var timer_processTime = 0.0 # Current timer

var toList = [] 			# List of pointers of all extraction conveyors
var fromList = []			# List of pointers of all insertion conveyors

# BOOLEANS
var isProcessing = false	# General:   		True when building is processing | False when building is not processing
var autoCraft = false		# General: 			True when always trying to process | False when not always trying to process
var moveMode = false		# Move mode: 		True when moving structure | False when not moving structure
var canBePlaced = false		# Move mode: 		True when structure can be placed | False when structure is over other structures
var dragDetectMode = false	# Drag Detect Mode: True when checking for finger movement whilst pressing child button
var hasDragged = false		# Drag Detect Mode: True is a finger has been dragged whilst pressing a chi8ld button


# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]  OR  [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func configure(structureData,structType): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	structureName = structureData[0]
	structureType = structType
	if structType == "Building":
		internalStorage = [structureData[1],structureData[2]]
		processTime = structureData[-2]
	elif structType == "Storage":
		internalStorage = [structureData[1]]
	# We edit the storage data
	for internal in internalStorage:
		for storage in internal:
			storage.insert(1,0) # At index 1 add a 0 to represent current resource amount ["Cobble",2] -> ["Cobble",0,2]
	shapeData = structureData[-1]
	
	rect_size = Vector2( ctrlFactoryFloor.tileSize * shapeData[0].size()  , ctrlFactoryFloor.tileSize * shapeData.size() )
	get_node("grdInfo").rect_size = rect_size

func updateUI(structureData,structType): # Called when we want to update the display nodes for the user
	
	# Update the structure label
	var labStructure = get_node("labStructure")
	labStructure.rect_position = Vector2(0,rect_size[1]/2)
	labStructure.rect_size = Vector2(rect_size[0],rect_size[1]/2)
	labStructure.text = structureName
	
	# Update the structure image
	texture = load("res://Assets/"+structType+"/img_"+structureData[0].to_lower()+".png")
	
	# Update process info
	var grdInfo = get_node("grdInfo")
	# Iterate through the input|divider|output children
	var grdInfoChildRefs = grdInfo.get_children() # Get a list of all children (input|divider|output)
	for childRefsPos in range( grdInfoChildRefs.size() ): # Iterate through the children by index
		
		var grdInfoChild = grdInfoChildRefs[childRefsPos] # Get current child
		print(grdInfoChild.name)
		
		if "Storage" in grdInfoChild.name: # Are they a tmpStorage child
			if childRefsPos < internalStorage[0].size(): # Is this an input tmpStorage
				grdInfoChild.get_node("labCurrent").text = str( internalStorage[0][childRefsPos][1] )
				grdInfoChild.get_node("labCapacity").text = str( internalStorage[0][childRefsPos][2] )
			else: # Is this an output tmpStorage
				grdInfoChild.get_node("labCurrent").text = str( internalStorage[1][childRefsPos-internalStorage[0].size()-1][1] )
				grdInfoChild.get_node("labCapacity").text = str( internalStorage[1][childRefsPos-internalStorage[0].size()-1][2] )
		else: # Are they a tmpProcess child
			grdInfoChild.get_node("labProcess").text = "-["+str(processTime)+"s]->"

func _process(_delta):
	
	# IF WE ARE MOVING THE STRUCTURE
	if moveMode == true:
		# Move the building in tile steps with the camera
		rect_position[0] = stepify( camFactory.position[0] - ctrlFactoryFloor.rect_position[0] - rect_size[0]/2 , ctrlFactoryFloor.tileSize )
		rect_position[0] = clamp(rect_position[0] , 0 , FactorySpace.rect_size[0] - rect_size[0])
		rect_position[1] = stepify( camFactory.position[1] - ctrlFactoryFloor.rect_position[1] - rect_size[1]/2 , ctrlFactoryFloor.tileSize )
		rect_position[1] = clamp(rect_position[1] , 0 , FactorySpace.rect_size[1] - rect_size[1])
		
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
		for child in get_children(): # Check every child node
			if "Tile" in child.name: # If the child node is a tmpTileDetect
				if child.check_isTileFree(masterTile) == false: # If the child says it's above a structure
					canBePlaced = false # We can't place the structure
					get_node("tmpConfirm/btnYes").modulate = Color(grey,grey,grey) # Colour the YES button in the Confirm menu grey
	
	# Display Info
	if Globals.infoIsDisplayed == true:
		self_modulate = Color(grey,grey,grey) # Colour grey
		get_node("grdInfo").visible = true # Make the process info visible
		get_node("labStructure").visible = false # Make the structure label invisible
	else:
		self_modulate = Color(1,1,1) # Removing any colouring
		get_node("grdInfo").visible = false # Make the process info invisible
		get_node("labStructure").visible = true # Make the structure label visible

func enable_moveMode(): # Called when we want to move this structure
	
	moveMode = true # Enable local move mode
	Globals.moveStructureMode = true # Enable global move mode
	
	var tileSize = ctrlFactoryFloor.tileSize # Get tilesize for movement
	
	# Add move Confirm Menu
	var newConfirm = templateNode.get_node("tmpConfirm").duplicate() # Get the Confirm Menu template
	newConfirm.get_node("labMenu").text = "Place Here?" # Set the Confirm Menu text
	newConfirm.menuResultNode = self # We give the menu our node address so it can communicate the true/false result to us (see: menuResult)
	newConfirm.menuID = "move" # We give the menu a string ID so we can interpret the true/false result (see: menuResult)
	add_child(newConfirm) # Add the Confirm Menu as a child
	
	# Add shape detectors
	for row in range( shapeData.size() ): # For every row of our shape
		for col in range( shapeData[row].size() ): # For every column in that row
			if shapeData[row][col] != null: # If our shape is there
				var newTileDetect = templateNode.get_node("tmpTileDetect").duplicate() # Get the TileDetect template
				newTileDetect.position = Vector2( tileSize * col , tileSize * row ) # Set its position to the correct tile in our shape
				newTileDetect.modulate = Color(1,1,1,0.2) # Make it slightly transparent
				newTileDetect.gridVector = [row,col] # Tell it what local grid position it has in our shape
				add_child(newTileDetect) # Add the TileDetect as a child

func disable_moveMode(): # Called when we have stopped moving this structure
	
	moveMode = false # Disable local move mode
	Globals.moveStructureMode = false # Disable global move mode
	
	# Delete all the move-related nodes ( ConfirmMenu | TileDetect )
	for child in get_children(): # Check every child node
		if "Confirm" in child.name or "Tile" in child.name: # If the child is a tmpConfirm or tmpTileDetect
			remove_child(child) # Remove the child node

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

func menuResult(menuID,result): # Called by a menu; the menuID tells us the menu type (move|delete|etc.) | the result is the result
	
	if menuID == "move": # This is the result of the move ConfirmMenu (true|false)
		
		if result == true: # If the user tapped YES
			if canBePlaced == true: # Check if the structure can be placed
				disable_moveMode() # Stop local and global move modes
				addSelfToFactory()
			else:
				print("can't be placed!")
		else: # If the user tapped NO
			disable_moveMode() # Stop local and global move modes
			get_parent().remove_child(self) # Destroy self









