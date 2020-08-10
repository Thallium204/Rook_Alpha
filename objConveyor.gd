extends "res://classFactoryEntity.gd"

# Variables unique to Conveyors
var conveyorSpeed = 0


# structureData = [ nameID , inputResList , outputResList , processTime , shapeData ]  OR  [ nameID , internalStorageList , shapeData ]
# structType = "Building" or "Storage"
func configure(structureData,structType): # Called when we want to initialise the internal structure
	# Here we take the data provided by the Banks (structureData), in some cases edit it, and assign it to it's internal variable
	structureName = structureData[0]
	structureType = structType
	shapeData = structureData[-1]
	conveyorSpeed = structureData[1]
	# Set the image size
	rect_size = Vector2( ctrlFactoryFloor.tileSize * shapeData[0].size()  , ctrlFactoryFloor.tileSize * shapeData.size() )

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	texture = load("res://Assets/Conveyor/img_"+structureName.to_lower()+".png")

func _process(_delta):
	#print(Globals.drawConveyorMode)
	pass

func onStructure_Pressed(tile): # Called when our structure is pressed
	
	if Globals.drawConveyorMode == "ready":
		# Begin the conveyor drawing
		Globals.drawConveyorMode = "moving"
	
	# Handle general
	onStructure_Pressed_General(tile)

func onStructure_Released(tile): # Called when our structure is pressed
	
	if Globals.drawConveyorMode == "moving":
		# End the conveyor drawing
		Globals.drawConveyorMode = "ready"
	
	if hasDragged == false:
		
		# Handle general
		onStructure_Released_General(tile)
