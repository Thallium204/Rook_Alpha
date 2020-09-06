extends NinePatchRect

var infoNode = null
var functionYet = false
var processDisplay = 0

func _process(_delta):
	updateInfo()

func updateProcessorInfo():
	var currentProcess = infoNode.processesData[infoNode.processNames[infoNode.processIndex]] # Get the processesData for the current
	
	# Colour modulate the process change buttons
	if infoNode.processIndex < infoNode.processNames.size()-1:
		$infoProcessor/ctrlRightProcess.modulate = Color(1,1,1)
	else:
		$infoProcessor/ctrlRightProcess.modulate = Color(0.3,0.3,0.3)
	if 0 < infoNode.processIndex:
		$infoProcessor/ctrlLeftProcess.modulate = Color(1,1,1)
	else:
		$infoProcessor/ctrlLeftProcess.modulate = Color(0.3,0.3,0.3)
	
	# Handle Inputs
	var inputSolid = $infoProcessor/inputBuffers/inputSolid # The vertical stack of input buffers
	for inputPos in range(3): # For every texBuffer
		# Do we need to display the buffer
		var bufferIsVisible = bool( inputPos < currentProcess["inputBuffers"].size() )
		var texInputBuffer = inputSolid.get_node("texBuffer"+str(inputPos))
		texInputBuffer.visible = bufferIsVisible
		if bufferIsVisible: # If we still have an input buffer to display
			var texResource = texInputBuffer.get_node("texResource")
			var labAmount = texResource.get_node("labAmount")
			var bufferInfo = currentProcess["inputBuffers"][inputPos] # Get the buffer data
			labAmount.text = str(bufferInfo["current"])
			labAmount.modulate = Color( 1,1,1, min(bufferInfo["current"],1) )
			labAmount.rect_scale = Vector2.ONE * texResource.rect_size[1]/64
			texResource.texture = load("res://Assets/Resources/img_"+bufferInfo["name"]+".png")
			texResource.modulate = Color( 1,1,1, clamp(0.3,bufferInfo["current"],1) )
	
	# Handle Process
	var prgProcess = $infoProcessor/prgProcess # The vertical stack of process info
	if infoNode.isProcessing == true:
		prgProcess.value = 100*infoNode.progPerc
	else:
		prgProcess.value = 0
	
	# Handle Outputs
	var outputSolid = $infoProcessor/outputBuffers/outputSolid # The vertical stack of input buffers
	for outputPos in range(3): # For every texBuffer
		# Do we need to display the buffer
		var bufferIsVisible = bool( outputPos < currentProcess["outputBuffers"].size() )
		var texInputBuffer = outputSolid.get_node("texBuffer"+str(outputPos))
		texInputBuffer.visible = bufferIsVisible
		if bufferIsVisible: # If we still have an input buffer to display
			var texResource = texInputBuffer.get_node("texResource")
			var labAmount = texResource.get_node("labAmount")
			var bufferInfo = currentProcess["outputBuffers"][outputPos] # Get the buffer data
			labAmount.text = str(bufferInfo["current"])
			labAmount.modulate = Color( 1,1,1, min(bufferInfo["current"],1) )
			labAmount.rect_scale = Vector2.ONE * texResource.rect_size[1]/64
			texResource.texture = load("res://Assets/Resources/img_"+bufferInfo["name"]+".png")
			texResource.modulate = Color( 1,1,1, clamp(0.3,bufferInfo["current"],1) )
	
	# Draw the image
	$infoProcessor/texStructure.texture = load(infoNode.imageDirectory + "/img_"+infoNode.entityName.to_lower() + ".png")

func updateHolderInfo():
	var internalStorage = infoNode.internalStorage # Get the processesData for the current
	
	# Handle Internal
	var texInternalStorage = $infoHolder/texInternalStorage # The vertical stack of input buffers
	for internalPos in range(1):
		if internalPos < internalStorage.size(): # If we still have an input buffer to display
			var bufferInfo = internalStorage[internalPos] # Get the buffer data
			texInternalStorage.get_node("labAmount").text = str(bufferInfo["current"])
			texInternalStorage.get_node("labAmount").modulate = Color(1,1,1,min(bufferInfo["current"],1))
			#texInternalStorage.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
			if bufferInfo["name"] == "":
				texInternalStorage.get_node("texResource").texture = load("res://Assets/Resources/img_empty_"+bufferInfo["type"]+".png")
			else:
				texInternalStorage.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["name"]+".png")
			var alpha = clamp(0.3,bufferInfo["current"],1)
			texInternalStorage.get_node("texResource").modulate = Color(1,1,1,alpha)
			texInternalStorage.modulate = Color(1,1,1,1)
		else:
			texInternalStorage.get_node("labAmount").text = ""
			texInternalStorage.modulate = Color(1,1,1,0)
	
	# Draw the image
	$infoHolder/texStructure.texture = infoNode.get_node("sprStructure").texture

func updateInfo():
	
	$infoName.visible = false
	$infoProcessor.visible = false
	$infoHolder.visible = false
	
	if infoNode == null:
		return
	
	$infoName.visible = true
	$infoName/labName.text = " "+infoNode.entityName
	
	if infoNode.entityType == "Structure":
		
		$infoName/labType.text = "("+infoNode.entityClass+") "
		
		if infoNode.entityClass == "Processor":
			
			$infoProcessor.visible = true
			updateProcessorInfo()
		
		elif infoNode.entityClass == "Holder":
			
			$infoHolder.visible = true
			updateHolderInfo()
	
	elif infoNode.entityType == "Connector":
		
		$hgrdName/labType.text = "("+infoNode.connectorType+") "
		
		if infoNode.connectorType == "Conveyor":
			
			pass

func _on_btnLeft_pressed():
	if infoNode.isProcessing == true:
		return
	if infoNode.processIndex > 0:
		infoNode.processIndex -= 1
		infoNode.updateTimers()


func _on_btnRight_pressed():
	if infoNode.isProcessing == true:
		return
	if infoNode.processIndex < infoNode.processesData.size()-1:
		infoNode.processIndex += 1
		infoNode.updateTimers()
