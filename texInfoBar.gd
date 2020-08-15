extends NinePatchRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var infoNode = null

func _process(_delta):
	updateInfo()

func updateInfo():
	
	if infoNode != null:
		if infoNode.structureType == "conveyor":
			return
	
	if infoNode != null:
		
		
		$hgrdName.visible = true
		$hgrdPanels.visible = true
		
		var internalStorage = infoNode.internalStorage
		$hgrdName/labName.text = " "+infoNode.structureName
		$hgrdName/labType.text = "("+infoNode.structureType+") "
		
		# Handle Inputs
		var vgrdInputList = $hgrdPanels/vgrdInputList
		for inputPos in range(3):
			var hgrdInput = vgrdInputList.get_node("hgrdInput"+str(inputPos+1))
			if inputPos < internalStorage[0].size():
				var storageInfo = internalStorage[0][inputPos]
				hgrdInput.visible = true
				hgrdInput.get_node("labCurrent").text = str(storageInfo[1])
				hgrdInput.get_node("labCapacity").text = str(storageInfo[2])
				if storageInfo[0] == "":
					hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_empty_"+storageInfo[-1].to_lower()+".png")
				else:
					hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_"+storageInfo[0].to_lower()+".png")
			else:
				hgrdInput.visible = false
		
		# If the structure is a building
		if infoNode.structureType == "Processor":
			# Handle Process
			var vgrdProcess = $hgrdPanels/vgrdProcess
			vgrdProcess.visible = true
			var labProcess = vgrdProcess.get_node("tmpProcess/labProcess")
			labProcess.text = "-[" + str(infoNode.processTime) + "]->"
			if infoNode.isProcessing == true:
				labProcess.percent_visible = infoNode.progPerc
			else:
				labProcess.percent_visible = 1
			
			# Handle Outputs
			var vgrdOutputList = $hgrdPanels/vgrdOutputList
			vgrdOutputList.visible = true
			for outputPos in range(3):
				var hgrdOutput = vgrdOutputList.get_node("hgrdOutput"+str(outputPos+1))
				if outputPos < internalStorage[1].size():
					hgrdOutput.visible = true
					var storageInfo = internalStorage[1][outputPos]
					hgrdOutput.get_node("labCurrent").text = str(storageInfo[1])
					hgrdOutput.get_node("labCapacity").text = str(storageInfo[2])
					hgrdOutput.get_node("texResource").texture = load("res://Assets/Resources/img_"+storageInfo[0].to_lower()+".png")
				else:
					hgrdOutput.visible = false
		elif infoNode.structureType == "Holder":
			$hgrdPanels/vgrdProcess.visible = false
			$hgrdPanels/vgrdOutputList.visible = false
		
		$hgrdPanels/texStructure.texture = infoNode.get_node("sprStructure").texture
		
	else:
		$hgrdName.visible = false
		$hgrdPanels.visible = false



