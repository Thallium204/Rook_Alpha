extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var FactoryFloor = Globals.get_node("FactoryFloor")

onready var conveyorCrammingFactor = Globals.conveyorCrammingFactor

func addConveyor(conveyorData,conveyorPair):
	
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
