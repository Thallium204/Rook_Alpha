extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var UIPermission = true

var intStorage = [null,0,0]
var extractAmount = 0

var toList = []
var toPriority = 0

var fromList = []
var fromPriority = 0

func killFather():
	get_parent().removeSelf()

func animateByPercentage(animate,_percentage):
	var texSegment = get_node("texSegment")
	var _texResource = get_node("texResource")
	if animate == true:
		texSegment.texture.pause = false
	else:
		texSegment.texture.pause = true

func getStorage():
	return intStorage

func getRoom(resName):  # Used to check for potential receivers
	#print("SEGMENT getRoomRequest: ",intStorage)
	if intStorage[0] == resName: # If we're being given our current resource
		return intStorage[2] - intStorage[1] # return the current room avaliable
	elif intStorage[0] == null: # If the conveyor is empty
		return intStorage[2] # return maximum room
	else: # If we're being given a different resource than we have
		return 0 # return no room

func getResAmount(resName): # Used to check for potential pushers
	#print("SEGMENT getResAmountRequest: ",resName," -> ",intStorage)
	if intStorage[0] == resName: # If we have a certain resource to pull
		return intStorage[1] # return the current resource amount
	elif resName == null: # If we can pull any resource
		return intStorage[1]
	# If we've made it this far there was no relevant storage (i.e. trying to receive resources from empty storage)
	return 0 # return no resources

func editIntStorage(resName,value,_io):
	intStorage[0] = resName
	intStorage[1] += value
	#if intStorage[1] == 0:
	#	intStorage[0] = null
	
func advancePriority(type,_resName=null):
	if type == "FROM":
		fromPriority = (fromPriority+1)%fromList.size()
	else:
		toPriority = (toPriority+1)%toList.size()

func updateEntityUI():
	# Draw the resource if there
	if intStorage[1] > 0: # If there's any resources in this segment
		get_node("texResource").texture = load("res://Sprites/Resources/img_"+intStorage[0].to_lower()+".png") # Set texture based upon resource
		get_node("texResource").visible = true
	else:
		get_node("texResource").visible = false

func pushForward():
	
	if intStorage[1] > 0: # if we have something to push
		var havePushed = false
		var stopAt = int(1*toPriority) # Create a copy of the value toPriority
		while havePushed == false:
			var targetEntity = toList[toPriority] # Get new target
			# if we are the priority AND there's enough room for us to push into
			if targetEntity.findPriority(intStorage[0]) == self and targetEntity.getRoom(intStorage[0]) > 0:
				var amountToPush = min( targetEntity.getRoom(intStorage[0]) , intStorage[1] )
				editIntStorage(intStorage[0],-amountToPush,"output") # Take resources
				targetEntity.editIntStorage(intStorage[0],amountToPush,"input") # Push resources
				targetEntity.advancePriority("FROM",intStorage[0]) # Move fromRoundRobin
				havePushed = true
			advancePriority("TO")
			if toPriority == stopAt: # If we've tested every option and still can't push
				havePushed = true # Exit the loop
	else: # If we are holding nothing set our resource type to null
		intStorage[0] = null

func findPriority(resID):
	var havePriority = false
	var stopAt = int(1*fromPriority) # Create a copy of the value fromPriority
	while havePriority == false:
		var pusherEntity = fromList[fromPriority] # Get new pusher
		# if we are the priority and there's something to push to us
		#print("SEGMENT findPriority: ",pusherEntity.toList[pusherEntity.toPriority]," == ",self," and ",pusherEntity.getResAmount(intStorage[0])," > ",0)
		if pusherEntity.toList[pusherEntity.toPriority] == self and pusherEntity.getResAmount(resID) > 0:
			return pusherEntity
		else: # if we aren't the priority or there's nothing to push to us
			advancePriority("FROM") # try the next option
		if fromPriority == stopAt: # If we've tested every option and still can't push
			havePriority = true # Exit the loop
			return fromList[stopAt]

func _process(_delta):
	
	# Prevent clicking when menu is open
	if Globals.isMenuOpen == false:
		UIPermission = true
	else:
		UIPermission = false

func _on_btnProcess_released():
		# If we're creating a conveyor
	if Globals.addConveyorMode == true and UIPermission == true:
		if Globals.conveyorPair[0] == null: # If we're the first selection (FROM)
			Globals.conveyorPair[0] = self
		elif Globals.conveyorPair[1] == null and Globals.conveyorPair[0] != self: # If we're the second selection (TO) but not the first
			Globals.conveyorPair[1] = self
			Globals.initialiseConveyorData()
