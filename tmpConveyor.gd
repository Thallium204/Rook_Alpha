extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryFloor = Globals.get_node("FactoryFloor")

# Deemed by building connection
var resNameID = null # i.e. Cobble
var connectedBuildingNames = null # [ name (from) , name (to) ]
var noOfSegments = 0

# Deemed by conveyor type
var nameID = null
var extractAmount = null # Amount extracted out of fromBuilding
var conveyorSpeed = 0 # Time taken to roll forward
var segmentBuffer = null # Resource capacity for each segment

# Dynamic Conveyor Inventory
var segmentResList = []
var segmentPosList = []
var extractTimer = 0.0
var conveyorTimer = 0.0
var turnedOn = false

func configureConveyorData(conveyorData):
	nameID = conveyorData[0]
	extractAmount = conveyorData[1]
	conveyorSpeed = conveyorData[2]
	segmentBuffer = conveyorData[3]
	
	for i in range(noOfSegments):
		segmentResList.append(0)
	
	updateConveyorUI()

func updateConveyorUI():
	for segmentID in range(segmentResList.size()):
		if segmentResList[segmentID] != 0: # If there are resources in the segment
			get_node("texResUI_"+str(segmentID)).visible = true # draw them
		else:
			get_node("texResUI_"+str(segmentID)).visible = false # draw them

func _process(delta):
	
	if turnedOn == true: # If the conveyor is active
		
		# Progress Timers
		conveyorTimer += delta
		
		var fromBuilding = FactoryFloor.get_node(connectedBuildingNames[0])
		var toBuilding = FactoryFloor.get_node(connectedBuildingNames[1])
		
		# If its time to push the conveyor
		if conveyorTimer >= conveyorSpeed: # If its time to push the conveyor
			
			# Push in toBuilding
			for resCost in toBuilding.inputResList: # Go through all the toBuilding's resource costs
				if resCost[0] == resNameID: # If we find our resource
					if resCost[1] < resCost[2]: # If there is room to input
						var insertAmount = min( resCost[2]-resCost[1] , segmentResList[-1] ) # Compute how much to insert
						segmentResList[-1] -= insertAmount # Take resources in final segment
						resCost[1] += insertAmount # Place them in the toBuilding
			
			# Pull along segments
			for segmentPos in range(noOfSegments-1,0,-1):
				# Check if we have room
				var segRoom = segmentBuffer - segmentResList[segmentPos]
				if segRoom > 0: # If we have room in our segment
					var transferAmount = min( segRoom , segmentResList[segmentPos-1] )
					segmentResList[segmentPos-1] -= transferAmount # Take resources in adjacent segment
					segmentResList[segmentPos] += transferAmount # Place them in this segment
			
			# Pull out of fromBuilding
			var segRoom = segmentBuffer - segmentResList[0]
			var pullAmount = min( min( fromBuilding.outputResList[1] , segRoom ) , extractAmount )
			if pullAmount > 0: # If we can extract something
				fromBuilding.outputResList[1] -= pullAmount
				segmentResList[0] += pullAmount
			conveyorTimer = 0.0
			
			updateConveyorUI()
			fromBuilding.updateBuildingUI()
			toBuilding.updateBuildingUI()



