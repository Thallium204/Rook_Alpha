extends NinePatchRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var infoNode = null
var functionYet = false
var processDisplay = 0

func _process(_delta):
	updateInfo()

func updateInfo():
	
	if infoNode == null:
		$hgrdName.visible = false
		$hgrdProcess.visible = false
		return
	
	$hgrdName.visible = true
	$hgrdProcess.visible = true
	$hgrdName/labName.text = " "+infoNode.entityName
	
	if infoNode.entityType == "Structure":
		
		$hgrdName/labType.text = "("+infoNode.structureType+") "
		
		if infoNode.structureType == "Processor":
			
			$hgrdProcess/ctrlLeftProcess/btnLeft.visible = true 	# We need process change
			$hgrdProcess/ctrlRightProcess/btnRight.visible = true 	# We need process change
			
			var currentProcess = infoNode.processData[infoNode.processIndex] # Get the processData for the current
			
			# Colour modulate the process change buttons
			if infoNode.processIndex < infoNode.processData.size()-1:
				$hgrdProcess/ctrlRightProcess/btnRight.modulate = Color(1,1,1)
			else:
				$hgrdProcess/ctrlRightProcess/btnRight.modulate = Color(0.3,0.3,0.3)
			if 0 < infoNode.processIndex:
				$hgrdProcess/ctrlLeftProcess/btnLeft.modulate = Color(1,1,1)
			else:
				$hgrdProcess/ctrlLeftProcess/btnLeft.modulate = Color(0.3,0.3,0.3)
			
			# Handle Inputs
			var texInputBuffer = $hgrdProcess/texInputBuffer # The vertical stack of input buffers
			texInputBuffer.visible = true
			for inputPos in range(1):
				if inputPos < currentProcess["inputBuffers"].size(): # If we still have an input buffer to display
					var bufferInfo = currentProcess["inputBuffers"][inputPos] # Get the buffer data
					texInputBuffer.visible = true
					texInputBuffer.get_node("labAmount").text = str(bufferInfo["bufferCurrent"])
					texInputBuffer.get_node("labAmount").modulate = Color(1,1,1,min(bufferInfo["bufferCurrent"],1))
					#texInputBuffer.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					texInputBuffer.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
					var alpha = clamp(0.3,bufferInfo["bufferCurrent"],1)
					texInputBuffer.get_node("texResource").modulate = Color(1,1,1,alpha)
				else:
					texInputBuffer.get_node("labAmount").text = ""
					texInputBuffer.modulate = Color(1,1,1,0)
			
			# Handle Process
			var prgProcess = $hgrdProcess/prgProcess # The vertical stack of process info
			prgProcess.visible = true
			if infoNode.isProcessing == true:
				prgProcess.value = 100*infoNode.progPerc
			else:
				prgProcess.value = 0
			
			# Handle Outputs
			var texOutputBuffer = $hgrdProcess/texOutputBuffer # The vertical stack of input buffers
			texOutputBuffer.visible = true
			for outputPos in range(1):
				if outputPos < currentProcess["outputBuffers"].size(): # If we still have an input buffer to display
					var bufferInfo = currentProcess["outputBuffers"][outputPos] # Get the buffer data
					texOutputBuffer.visible = true
					texOutputBuffer.get_node("labAmount").text = str(bufferInfo["bufferCurrent"])
					texOutputBuffer.get_node("labAmount").modulate = Color(1,1,1,min(bufferInfo["bufferCurrent"],1))
					#texOutputBuffer.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					texOutputBuffer.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
					var alpha = clamp(0.3,bufferInfo["bufferCurrent"],1)
					texOutputBuffer.get_node("texResource").modulate = Color(1,1,1,alpha)
				else:
					texOutputBuffer.visible = false
		
		elif infoNode.structureType == "Holder":
			
			return
			
			$hgrdProcess/vgrdProcess.visible = false 				# We dont need process
			$hgrdProcess/vgrdOutputList.visible = false 			# We don't need output buffers
			$hgrdProcess/ctrlLeftProcess/btnLeft.visible = false 	# We don't need process change
			$hgrdProcess/ctrlRightProcess/btnRight.visible = false 	# We don't need process change
			
			# Handle Inputs
			var vgrdInputList = $hgrdProcess/vgrdInputList # The vertical stack of input buffers
			for inputPos in range(1):
				var hgrdInput = vgrdInputList.get_node("hgrdInput"+str(inputPos+1)) # Individual internal Buffer
				if inputPos < infoNode.internalStorage.size(): # If we still have an internal buffer to display
					var bufferInfo = infoNode.internalStorage[inputPos] # Get the buffer data
					hgrdInput.visible = true
					hgrdInput.get_node("labCurrent").text = str(bufferInfo["bufferCurrent"])
					hgrdInput.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					if bufferInfo["resourceName"] == "":
						hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_empty_"+bufferInfo["resourceType"].to_lower()+".png")
					else:
						hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
				else:
					hgrdInput.visible = false
		
		# Regardless of StructureType draw the image
		$hgrdProcess/texStructure.texture = infoNode.get_node("sprStructure").texture
	
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
