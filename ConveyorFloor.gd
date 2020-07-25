extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactoryFloor = Globals.get_parent()

func addConveyor2(conveyorData,conveyorPair):
	
	var nameID = conveyorData[0] # Isolate the name index from conveyorData
	var newConveyor = templateNode.get_node("tmpConveyor").duplicate() # Create new conveyor from template as a variable
	newConveyor.set_name("tex"+nameID) # Set correctly formated name i.e. "Standard" -> "texStandard"
	
	var fromBuilding = FactoryFloor.get_node(conveyorPair[0])
	var toBuilding = FactoryFloor.get_node(conveyorPair[1])
	var fromBuildingPos = fromBuilding.rect_position + fromBuilding.rect_size/2 # Get center of building
	var toBuildingPos = toBuilding.rect_position + toBuilding.rect_size/2 # Get center of building
	
	# Drawing the Conveyor
	newConveyor.rect_position = fromBuildingPos - newConveyor.rect_size/2 # Set conveyor midpoint to building midpoint
	newConveyor.rect_pivot_offset = newConveyor.rect_size/2
	var relDistance = toBuildingPos - fromBuildingPos
	var rotationDegrees = rad2deg(Vector2(0,1).angle_to(relDistance))
	newConveyor.rect_rotation = rotationDegrees
	var noOfSegments = relDistance.length()/newConveyor.rect_size[1]+1
	newConveyor.rect_size = Vector2(80,relDistance.length())
	
	# Initialising the variables
	newConveyor.resNameID = fromBuilding.outputResList[0]
	newConveyor.connectedBuildingNames = conveyorPair
	var extraSpace = noOfSegments - int(noOfSegments)
	newConveyor.noOfSegments = int(noOfSegments-3)
	newConveyor.turnedOn = true
	
	
	var segmentPosList = []
	var resClearnace = Vector2(80,80) - templateNode.get_node("tmpResource").rect_size
	for segmentID in range(noOfSegments-3):
		
		segmentPosList.append( Vector2(0,120) + Vector2(0,80)*(segmentID+extraSpace/2) + resClearnace/2 )
		
		var newResUI = templateNode.get_node("tmpResource").duplicate() # Create new resource UI from template as a variable
		newResUI.set_name("texResUI_"+str(segmentID)) # Set correctly formated name
		newResUI.texture = load("res://Sprites/Resources/img_"+newConveyor.resNameID.to_lower()+".png") # Set texture based upon nameID
		newResUI.rect_position = segmentPosList[-1]
		newResUI.rect_pivot_offset = newResUI.rect_size/2
		newResUI.rect_rotation -= rotationDegrees
		newConveyor.add_child(newResUI)
		
		#var newMovingResUI = templateNode.get_node("tmpResource").duplicate() # Create new moving resource UI from template as a variable
		#newMovingResUI.set_name("texMovingResUI_"+str(segmentID)) # Set correctly formated name
		#newMovingResUI.texture = load("res://Sprites/Resources/img_"+newConveyor.resNameID.to_lower()+".png") # Set texture based upon nameID
		#newMovingResUI.rect_position = segmentPosList[-1]
		#newConveyor.add_child(newMovingResUI)
	
	newConveyor.segmentPosList = segmentPosList
	
	# Update the new building's internals
	newConveyor.configureConveyorData(conveyorData)
	
	add_child(newConveyor) # Create the actual node as a child of FactoryFloor (Grid)





func addConveyor(conveyorData,conveyorNodePair):
	
	Globals.numberOfBuildings += 1
	var _nameID = conveyorData[0] # Isolate the name index from conveyorData
	var newConveyorNode = templateNode.get_node("tmpConveyorNode").duplicate() # Create new conveyor from template as a variable
	newConveyorNode.set_name("ConveyorNode_"+str(Globals.numberOfBuildings)) # Set correctly formated name i.e. "Standard" -> "texStandard"
	
	var fromEntityShape = conveyorNodePair[0].rect_size
	var fromEntityPos = conveyorNodePair[0].rect_position + fromEntityShape/2 # Get center of entity
	var fromEntityRadius = min( fromEntityShape[0] , fromEntityShape[1] )/2
	
	var toEntityShape = conveyorNodePair[1].rect_size
	var toEntityPos = conveyorNodePair[1].rect_position + toEntityShape/2 # Get center of entity
	var toEntityRadius = min( toEntityShape[0] , toEntityShape[1] )/2
	
	# Drawing the Conveyor
	var vectorDistance = toEntityPos - fromEntityPos # the vector from fromEntity to toEntity
	var rotationDegrees = rad2deg(Vector2(0,1).angle_to(vectorDistance))
	var scalarDistance = float(vectorDistance.length()) # the length of that vector
	var fromDistanceModifier = fromEntityRadius/scalarDistance # the percentage of the way the fromEntity radius is along the line
	
	var usableDistance = scalarDistance - fromEntityRadius - toEntityRadius # the distance between the radii
	var floatNoOfSegments = usableDistance/Globals.conveyorSpacing # the float number of segments we can fit
	var noOfSegments = floor(floatNoOfSegments) # the actual number of segments we are going to add
	var textureScaleAmount = 1
	if noOfSegments == 0: # If the gap is very small
		noOfSegments = 1 # Create a single segment
	textureScaleAmount = floatNoOfSegments/noOfSegments # Adjust the texture scale
	var segmentDistance = usableDistance/noOfSegments # the distance between segment midpoints
	var segmentDistanceModifier = segmentDistance/scalarDistance # the percentage of the distance segmentDistance takes up
	
	# Initialising the variables
	newConveyorNode.noOfSegments = noOfSegments
	newConveyorNode.connectedEntityNodes = conveyorNodePair
	newConveyorNode.turnedOn = true
	
	# Getting segment positions
	var segRectCenter = templateNode.get_node("tmpSegment").get_node("texSegment").rect_size/2 # Center of segment texture
	var segmentPosList = []
	var runningModifier = fromDistanceModifier
	for _segmentPos in range(noOfSegments):
		runningModifier += segmentDistanceModifier/2
		segmentPosList.append( fromEntityPos + vectorDistance*runningModifier - segRectCenter )
		runningModifier += segmentDistanceModifier/2
	
	# Creating FROM texture
	var newTexture = templateNode.get_node("tmpSegment").get_node("texSegment").duplicate()
	newTexture.rect_position = segmentPosList[0] - vectorDistance*segmentDistanceModifier*0.95
	newTexture.rect_pivot_offset = newTexture.rect_size/2
	newTexture.rect_rotation = rotationDegrees
	newTexture.rect_scale = Vector2(1,textureScaleAmount)
	newConveyorNode.add_child(newTexture)
	
	# Creating TO texture
	newTexture = newTexture.duplicate()
	newTexture.rect_position = segmentPosList[-1] + vectorDistance*segmentDistanceModifier*0.95
	newConveyorNode.add_child(newTexture)
	
	# Creating Segment children
	for segID in range(segmentPosList.size()):
		
		var newSegment = templateNode.get_node("tmpSegment").duplicate() # Create new resource UI from template as a variable
		newSegment.set_name("texSegment_"+str(segID)) # Set correctly formated name
		newTexture = newSegment.get_node("texSegment")
		var _newResource = newSegment.get_node("texResource")
		#newSegment.texture = load("res://Sprites/Conveyors/img_segment.png") # Set texture
		newSegment.position = segmentPosList[segID]
		newTexture.rect_pivot_offset = newTexture.rect_size/2
		newTexture.rect_rotation = rotationDegrees
		newTexture.rect_scale = Vector2(1,textureScaleAmount)
		#newSegment.get_node("texResource").rect_scale = Vector2(1,1/textureScaleAmount) # Cancel the scaling for the child resource texture
		#newSegment.rect_rotation -= rotationDegrees
		newConveyorNode.add_child(newSegment)
	
	# Update the new building's internals
	newConveyorNode.configureConveyorData(conveyorData)
	
	add_child(newConveyorNode) # Create the actual node as a child of FactoryFloor (Grid)
