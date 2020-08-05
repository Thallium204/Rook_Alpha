extends "res://classFactoryEntity.gd"

# Variables unique to Buildings
var processTimer = 0.0

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure label
	get_node("labStructure").text = structureName
	
	# Update the structure image
	texture = load("res://Assets/Building/img_"+structureName.to_lower()+".png")
	
	# Update process info
	var grdInfo = get_node("grdInfo")
	# Iterate through the input|divider|output children
	var grdInfoChildRefs = grdInfo.get_children() # Get a list of all children (input|divider|output)
	for childRefsPos in range( grdInfoChildRefs.size() ): # Iterate through the children by index
		
		var grdInfoChild = grdInfoChildRefs[childRefsPos] # Get current child
		
		if "input" in grdInfoChild.name: # Are they a tmpStorage child
			grdInfoChild.get_node("labCurrent").text = str( internalStorage[0][childRefsPos][1] )
			grdInfoChild.get_node("labCapacity").text = str( internalStorage[0][childRefsPos][2] )
		elif "divider" in grdInfoChild.name: # Is this an output tmpStorage
			grdInfoChild.get_node("labProcess").text = "-["+str(processTime)+"s]->"
		elif "output" in grdInfoChild.name: # Are they a tmpProcess child
			grdInfoChild.get_node("labCurrent").text = str( internalStorage[1][childRefsPos-internalStorage[0].size()-1][1] )
			grdInfoChild.get_node("labCapacity").text = str( internalStorage[1][childRefsPos-internalStorage[0].size()-1][2] )

func _process(delta):
	
	# Prevent clicking when menu is open
	if Globals.isMenuOpen == false:
		canBeTouched = true
	else:
		canBeTouched = false
	
	# IF WE ARE PROCESSING
	if isProcessing == true:
		processTimer += delta
		if processTimer >= processTime: # If we have finished
			for output in internalStorage[1]:
				output[1] += output[2] # Gain resources
			processTimer = 0.0
			isProcessing = false
			get_node("tmpProgress").value = 0
			updateUI()
		else: # If we are still processing
			var progPerc = processTimer/float(processTime)
			#self.self_modulate = Color(1-progPerc,1,1-progPerc)
			get_node("tmpProgress").value = stepify(100*progPerc,0.1)
	
	if Globals.autoCraft == true and get_parent() != Globals.get_node("../templateNode"):
		tryToProcess()

func tryToProcess():
	# Check if we have required resources
	if haveEnoughResources() == true and haveEnoughStorage() == true and isProcessing == false and moveMode == false:
		# Deduct resource costs
		for input in internalStorage[0]:
			input[1] -= input[2]
		# Commense Processing
		isProcessing = true

func haveEnoughResources():
	for input in internalStorage[0]:
		if input[1] < input[2]:
			return false
	return true

func haveEnoughStorage():
	for output in internalStorage[1]:
		if output[1] > 0:
			return false
	return true




