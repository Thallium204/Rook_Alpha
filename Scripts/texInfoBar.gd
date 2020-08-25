extends NinePatchRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var infoNode = null
var functionYet = false
var processDisplay = 0

func _process(_delta):
	updateInfo()

func updateInfo():
	
	$infoName.visible = false
	$infoProcessor.visible = false
	$infoHolder.visible = false
	
	if infoNode == null:
		return
	
	$infoName.visible = true
	$infoName/labName.text = " "+infoNode.entityName
	
	if infoNode.entityType == "Structure":
		
		$infoName/labType.text = "("+infoNode.structureType+") "
		
		if infoNode.structureType == "Processor":
			
			$infoProcessor.visible = true
			
			var currentProcess = infoNode.processData[infoNode.processIndex] # Get the processData for the current
			
			# Colour modulate the process change buttons
			if infoNode.processIndex < infoNode.processData.size()-1:
				$infoProcessor/ctrlRightProcess.modulate = Color(1,1,1)
			else:
				$infoProcessor/ctrlRightProcess.modulate = Color(0.3,0.3,0.3)
			if 0 < infoNode.processIndex:
				$infoProcessor/ctrlLeftProcess.modulate = Color(1,1,1)
			else:
				$infoProcessor/ctrlLeftProcess.modulate = Color(0.3,0.3,0.3)
			
			# Handle Inputs
			var inputSolid = $infoProcessor/inputBuffers/inputSolid # The vertical stack of input buffers
			for inputPos in range(3):
				var texInputBuffer = inputSolid.get_node("texInputBuffer"+str(inputPos))
				if inputPos < currentProcess["inputBuffers"].size(): # If we still have an input buffer to display
					texInputBuffer.visible = true
					var bufferInfo = currentProcess["inputBuffers"][inputPos] # Get the buffer data
					texInputBuffer.get_node("texResource/labAmount").text = str(bufferInfo["bufferCurrent"])
					texInputBuffer.get_node("texResource/labAmount").modulate = Color(1,1,1,min(bufferInfo["bufferCurrent"],1))
					#texInputBuffer.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					texInputBuffer.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
					var alpha = clamp(0.3,bufferInfo["bufferCurrent"],1)
					texInputBuffer.get_node("texResource").modulate = Color(1,1,1,alpha)
					texInputBuffer.modulate = Color(1,1,1,1)
				else:
					texInputBuffer.visible = false
					texInputBuffer.get_node("texResource").texture = load("res://Assets/Menu/img_empty.png")
					texInputBuffer.get_node("texResource/labAmount").text = ""
					texInputBuffer.modulate = Color(1,1,1,0)
			
			# Handle Process
			var prgProcess = $infoProcessor/prgProcess # The vertical stack of process info
			if infoNode.isProcessing == true:
				prgProcess.value = 100*infoNode.progPerc
			else:
				prgProcess.value = 0
			
			# Handle Outputs
			var outputSolid = $infoProcessor/outputBuffers/outputSolid # The vertical stack of input buffers
			for outputPos in range(3):
				var texOutputBuffer = outputSolid.get_node("texOutputBuffer"+str(outputPos))
				if outputPos < currentProcess["outputBuffers"].size(): # If we still have an input buffer to display
					texOutputBuffer.visible = true
					var bufferInfo = currentProcess["outputBuffers"][outputPos] # Get the buffer data
					texOutputBuffer.get_node("texResource/labAmount").text = str(bufferInfo["bufferCurrent"])
					texOutputBuffer.get_node("texResource/labAmount").modulate = Color(1,1,1,min(bufferInfo["bufferCurrent"],1))
					#texOutputBuffer.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					texOutputBuffer.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
					var alpha = clamp(0.3,bufferInfo["bufferCurrent"],1)
					texOutputBuffer.get_node("texResource").modulate = Color(1,1,1,alpha)
					texOutputBuffer.modulate = Color(1,1,1,1)
				else:
					texOutputBuffer.visible = false
					texOutputBuffer.get_node("texResource").texture = load("res://Assets/Menu/img_empty.png")
					texOutputBuffer.get_node("texResource/labAmount").text = ""
					texOutputBuffer.modulate = Color(1,1,1,0)
			
			# Draw the image
			$infoProcessor/texStructure.texture = infoNode.get_node("sprStructure").texture
		
		elif infoNode.structureType == "Holder":
			
			$infoHolder.visible = true
			
			var internalStorage = infoNode.internalStorage # Get the processData for the current
			
			# Handle Internal
			var texInternalStorage = $infoHolder/texInternalStorage # The vertical stack of input buffers
			for internalPos in range(1):
				if internalPos < internalStorage.size(): # If we still have an input buffer to display
					var bufferInfo = internalStorage[internalPos] # Get the buffer data
					texInternalStorage.get_node("labAmount").text = str(bufferInfo["bufferCurrent"])
					texInternalStorage.get_node("labAmount").modulate = Color(1,1,1,min(bufferInfo["bufferCurrent"],1))
					#texInternalStorage.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					if bufferInfo["resourceName"] == "":
						texInternalStorage.get_node("texResource").texture = load("res://Assets/Resources/img_empty_"+bufferInfo["resourceType"].to_lower()+".png")
					else:
						texInternalStorage.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
					var alpha = clamp(0.3,bufferInfo["bufferCurrent"],1)
					texInternalStorage.get_node("texResource").modulate = Color(1,1,1,alpha)
					texInternalStorage.modulate = Color(1,1,1,1)
				else:
					texInternalStorage.get_node("labAmount").text = ""
					texInternalStorage.modulate = Color(1,1,1,0)
			
			# Draw the image
			$infoHolder/texStructure.texture = infoNode.get_node("sprStructure").texture
	
	elif infoNode.entityType == "Connector":
		
		$hgrdName/labType.text = "("+infoNode.connectorType+") "
		
		if infoNode.connectorType == "Conveyor":
			
			pass

func _on_btnLeft_pressed():
	if infoNode.isProcessing == true:
		return
	if infoNode.processIndex > 0:
		infoNode.processIndex -= 1


func _on_btnRight_pressed():
	if infoNode.isProcessing == true:
		return
	if infoNode.processIndex < infoNode.processData.size()-1:
		infoNode.processIndex += 1
