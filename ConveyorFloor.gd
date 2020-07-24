extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactoryFloor = Globals.get_node("FactoryFloor")

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
	var nameID = conveyorData[0] # Isolate the name index from conveyorData
	var newConveyorNode = templateNode.get_node("tmpConveyorNode").duplicate() # Create new conveyor from template as a variable
	newConveyorNode.set_name("ConveyorNode_"+str(Globals.numberOfBuildings)) # Set correctly formated name i.e. "Standard" -> "texStandard"
	
	var fromEntityShape = conveyorNodePair[0].rect_size
	var fromEntityPos = conveyorNodePair[0].rect_position + fromEntityShape/2 # Get center of entity
	var fromEntityRadius = min( fromEntityShape[0] , fromEntityShape[1] )/2
	
	var toEntityShape = conveyorNodePair[1].rect_size
	var toEntityPos = conveyorNodePair[1].rect_position + toEntityShape/2 # Get center of entity
	var toEntityRadius = min( toEntityShape[0] , toEntityShape[1] )/2
	
	# Drawing the Conveyor
	var vectorDistance = toEntityPos - fromEntityPos
	var scalarDistance = float(vectorDistance.length())
	var fromDistanceModifier = fromEntityRadius/scalarDistance
	var toDistanceModifier = 1-toEntityRadius/scalarDistance
	
	var usableDistance = scalarDistance - fromEntityRadius - toEntityRadius
	var floatNoOfSegments = usableDistance/Globals.conveyorSpacing
	var noOfSegments = ceil(floatNoOfSegments)
	var segmentDistance = usableDistance/noOfSegments
	var segmentDistanceModifier = segmentDistance/scalarDistance
	
	# Initialising the variables
	newConveyorNode.noOfSegments = noOfSegments+1
	#print(newConveyorNode.noOfSegments)
	newConveyorNode.connectedEntityNodes = conveyorNodePair
	newConveyorNode.turnedOn = true
	
	# Creating Children Segments
	var segRectCenter = templateNode.get_node("tmpSegment").rect_size/2 # Center of segment texture
	var segmentPosList = []
	for segmentPos in range(noOfSegments):
		segmentPosList.append( fromEntityPos + vectorDistance*(fromDistanceModifier + segmentPos*segmentDistanceModifier ) - segRectCenter )
	segmentPosList.append( fromEntityPos + vectorDistance*toDistanceModifier - segRectCenter )
	
	for segID in range(segmentPosList.size()):
		
		var newSegment = templateNode.get_node("tmpSegment").duplicate() # Create new resource UI from template as a variable
		newSegment.set_name("texSegment_"+str(segID)) # Set correctly formated name
		#newSegment.texture = load("res://Sprites/Conveyors/img_segment.png") # Set texture
		newSegment.rect_position = segmentPosList[segID]
		newSegment.rect_pivot_offset = newSegment.rect_size/2
		#newSegment.rect_rotation -= rotationDegrees
		newConveyorNode.add_child(newSegment)
	
	# Update the new building's internals
	newConveyorNode.configureConveyorData(conveyorData)
	
	add_child(newConveyorNode) # Create the actual node as a child of FactoryFloor (Grid)
