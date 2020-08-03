extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var ctrlFactoryFloor = get_parent()
onready var FactorySpace = ctrlFactoryFloor.get_node("../FactorySpace")
onready var camFactory = get_parent().get_node("../camFactory")

var structureNode = null

var structureName = "" 		# Name of the structure i.e. "Foundry"
var structureType = "" 		# Type of structure i.e. "Storage"
var internalStorage = [] 	# [inputStorage,outputStorage]  OR  [ioStorage]
var masterTile = 0			# top-right most tile [ row , col ]
var shapeData = [] 			# 2D array of FactoryFloor grid positions in shape of structure
var _levelData = [] 		# List of all upgrade modifiers

var processTime = 0 		# Time taken to complete a single process
var timer_processTime = 0.0 # Current timer

var toList = [] 			# List of pointers of all extraction conveyors
var fromList = []			# List of pointers of all insertion conveyors

var moveMode = true		# Are we placing the building
var canBePlaced = false
var isProcessing = false	# Are we processing
var dragDetectMode = false	# Are we checking for a finger drag
var hasDragged = false		# Has the user dragged a finger
var autoCraft = false		# Do we process always try to process


# Create the internal structure based on structureData and structType
# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]  OR  [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func configure(structData,structType):
	
	structureName = structData[0]
	structureType = structType
	if structType == "Building":
		internalStorage = [structData[1],structData[2]]
		processTime = structData[-2]
	elif structType == "Storage":
		internalStorage = [structData[1]]
	for internal in internalStorage:
		for storage in internal:
			storage.insert(1,0) # Add internal storage amount at 0
	shapeData = structData[-1]
	
	rect_size = Vector2( ctrlFactoryFloor.tileSize * shapeData[0].size()  , ctrlFactoryFloor.tileSize * shapeData.size() )
	get_node("grdInfo").rect_size = rect_size


func updateUI(structureData,structType):
	
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
	
	if moveMode == true:
		# Move the building with the camera in tile steps
		rect_position[0] = stepify( camFactory.position[0] - ctrlFactoryFloor.rect_position[0] - rect_size[0]/2 , ctrlFactoryFloor.tileSize )
		rect_position[0] = clamp(rect_position[0] , 0 , FactorySpace.rect_size[0] - rect_size[0])
		rect_position[1] = stepify( camFactory.position[1] - ctrlFactoryFloor.rect_position[1] - rect_size[1]/2 , ctrlFactoryFloor.tileSize )
		rect_position[1] = clamp(rect_position[1] , 0 , FactorySpace.rect_size[1] - rect_size[1])
		
		# Get current master tile
		masterTile = [ rect_position[1]/ctrlFactoryFloor.tileSize , rect_position[0]/ctrlFactoryFloor.tileSize ]
		
		# If we're moving we have a Confirm Menu
		var texConfirm = get_node("tmpConfirm")
		texConfirm.rect_scale = camFactory.zoom # Scale it appropriately
		
		# If the menu is off the bottom of the screen
		if rect_position[1] + rect_size[1] + texConfirm.rect_size[1] + 128 > FactorySpace.rect_size[1]:
			texConfirm.rect_position[1] = -256
		else:
			texConfirm.rect_position[1] = rect_size[1]
		# Update tmpTileDetects
		canBePlaced = true
		for child in get_children(): # Check every child node
			if "Tile" in child.name: # If the child is a tmpTileDetect
				if child.check_isTileFree(masterTile) == false:
					canBePlaced = false
	
	# Display Info
	if Globals.infoIsDisplayed == true:
		var col = Globals.infoColorModifier
		self_modulate = Color(col,col,col)
		get_node("grdInfo").visible = true
		get_node("labStructure").visible = true
	else:
		self_modulate = Color(1,1,1)
		get_node("grdInfo").visible = false
		get_node("labStructure").visible = true


func enable_moveMode():
	moveMode = true
	Globals.moveStructureMode = true
	
	var tileSize = ctrlFactoryFloor.tileSize
	
	# Add move confirm menu
	var newConfirm = templateNode.get_node("tmpConfirm").duplicate()
	newConfirm.rect_position = Vector2(0,shapeData.size()*tileSize) # Put the menu below the image
	newConfirm.get_node("labMenu").text = "Place Here?"
	newConfirm.menuResultNode = self
	newConfirm.menuID = "move"
	add_child(newConfirm)
	
	# Add shape detectors
	for row in range( shapeData.size() ):
		for col in range( shapeData[row].size() ):
			if shapeData[row][col] != null:
				var newTileDetect = templateNode.get_node("tmpTileDetect").duplicate()
				newTileDetect.position = Vector2( tileSize * col , tileSize * row )
				newTileDetect.modulate = Color(1,1,1,0.2)
				newTileDetect.gridVector = [row,col]
				add_child(newTileDetect)


func disable_moveMode():
	moveMode = false
	Globals.moveStructureMode = false
	
	# Delete all the move-related nodes
	for child in get_children(): # Check every child node
		if "Confirm" in child.name or "Tile" in child.name: # If the child is a tmpConfirm or tmpTileDetect
			remove_child(child)


func addSelfToFactory():
	# Update the shape data with the new grid positions  AND  update the pointerArray with this objects pointers
	for row in range( shapeData.size() ):
		for col in range( shapeData[row].size() ):
			if shapeData[row][col] != null:
				shapeData[row][col] = [0,0]
				shapeData[row][col][0] = masterTile[0] + row
				shapeData[row][col][1] = masterTile[1] + col
				ctrlFactoryFloor.pointerArray[ shapeData[row][col][0] ][ shapeData[row][col][1] ] = self
			else:
				shapeData[row][col] = null


func menuResult(menuID,result):
	
	if menuID == "move": # This is the result of the move ConfirmMenu
		
		if result == true: # If the user tapped YES
			if canBePlaced == true: # Check if the structure can be placed
				disable_moveMode() # Stop local and global move modes
				addSelfToFactory()
			else:
				print("can't be placed!")
		else: # If the user tapped NO
			disable_moveMode() # Stop local and global move modes
			get_parent().remove_child(self) # Destroy self









