extends "res://classFactoryEntity.gd"

onready var Quad = get_node("tmpQuad")

# Variables unique to Conveyors
var conveyorSpeed = 0
var testtimer = 0


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
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	texture = load("res://Assets/Conveyor/img_"+structureName.to_lower()+".png")

func _process(delta):
	testtimer += delta
#	snapConnection()
	# Dump resources from input buffer into main/output storage
#	internalStorage[1][1] += internalStorage[0][1]
#	internalStorage[0][1] = 0
#	if internalStorage[1][1] > internalStorage[1][2]:
#		internalStorage[1][1] = internalStorage[1][2]
	# snapConnection()
	pass
#
#func snapConnection(): # called every process tick to update snap connections
#
#	if !Quad.inputs.empty():
#		for i in Quad.inputs:
#			if i == "bodyQuadU":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0] - 1][shapeData[0][0][1]] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0] - 1][shapeData[0][0][1]] # entity being snapped to
#
#					# add from and to connections in both entities
#					fromList.append(snapEntity)
#					snapEntity.toList.append(self)
#			if i == "bodyQuadD":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0] + 1][shapeData[0][0][1]] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0] + 1][shapeData[0][0][1]] # entity being snapped to
#
#					# add from and to connections in both entities
#					fromList.append(snapEntity)
#					snapEntity.toList.append(self)
#			if i == "bodyQuadR":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] + 1] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] + 1] # entity being snapped to
#
#					# add from and to connections in both entities
#					fromList.append(snapEntity)
#					snapEntity.toList.append(self)
#			if i == "bodyQuadL":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] - 1] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] - 1] # entity being snapped to
#
#					# add from and to connections in both entities
#					fromList.append(snapEntity)
#					snapEntity.toList.append(self)
#
#	if !Quad.outputs.empty():
#		for i in Quad.outputs:
#			if i == "bodyQuadU":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0] - 1][shapeData[0][0][1]] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0] - 1][shapeData[0][0][1]] # entity being snapped to
#
#					# add from and to connections in both entities
#					toList.append(snapEntity)
#					snapEntity.fromList.append(self)
#			if i == "bodyQuadD":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0] + 1][shapeData[0][0][1]] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0] + 1][shapeData[0][0][1]] # entity being snapped to
#
#					# add from and to connections in both entities
#					toList.append(snapEntity)
#					snapEntity.fromList.append(self)
#			if i == "bodyQuadR":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] + 1] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] + 1] # entity being snapped to
#
#					# add from and to connections in both entities
#					toList.append(snapEntity)
#					snapEntity.fromList.append(self)
#			if i == "bodyQuadL":
#				if ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] - 1] != null:
#					var snapEntity = ctrlFactoryFloor.pointerArray[shapeData[0][0][0]][shapeData[0][0][1] - 1] # entity being snapped to
#
#					# add from and to connections in both entities
#					toList.append(snapEntity)
#					snapEntity.fromList.append(self)
#

func onStructure_Pressed(tile): # Called when our structure is pressed
	
	# Handle general
	onStructure_Pressed_General(tile)

func onStructure_Released(tile): # Called when our structure is pressed
	
	if Globals.drawConveyorMode == "moving":
		# End the conveyor drawing
		Globals.drawConveyorMode = "ready"
	
	if hasDragged == false:
		
		# Handle general
		onStructure_Released_General(tile)
