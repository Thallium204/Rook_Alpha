extends VBoxContainer

var load_objResStats = preload("res://Scenes/objResStats.tscn")

var processData

func configure(input_processData):
	
	processData = input_processData
	
	var margin
	var lab = Label.new()														# Input handling
	lab.rect_min_size = Vector2(0, 64)
	lab.text = "Inputs:"
	$HBoxContainer/VBoxContainer.add_child(lab)
	for inputBuffer in processData["inputBuffers"]:
		var objResStats = load_objResStats.instance()
		
		var tempCost = ceil(inputBuffer["cost"])
		var tempMod = inputBuffer["cost"] % 1
		if tempMod != 0:
			tempMod = 1 - tempMod
		
		objResStats.configure(tempCost, inputBuffer["name"])
		$HBoxContainer/VBoxContainer2.add_child(objResStats)
		
		lab = Label.new()
		lab.rect_min_size = Vector2(0, 64)
		lab.text = str(tempMod*100) + "%"
		$HBoxContainer/VBoxContainer3.add_child(lab)
		
		margin = MarginContainer.new()
		margin.rect_min_size = Vector2(0, 64)
		$HBoxContainer/VBoxContainer.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer2.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer3.add_child(margin)
	
	lab = Label.new()															# ProcessSpeed handling
	lab.rect_min_size = Vector2(0, 64)
	lab.text = "Speed:"
	$HBoxContainer/VBoxContainer.add_child(lab)
	lab = Label.new()
	lab.rect_min_size = Vector2(0, 64)
	lab.text = str(processData["processTime"]) + " sec"
	$HBoxContainer/VBoxContainer2.add_child(lab)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer2.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer3.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer3.add_child(margin)
	
	lab = Label.new()															# Output handling
	lab.rect_min_size = Vector2(0, 64)
	lab.text = "Outputs:"
	$HBoxContainer/VBoxContainer.add_child(lab)
	for outputBuffer in processData["outputBuffers"]:
		var objResStats = load_objResStats.instance()
		
		var tempCost = floor(outputBuffer["yield"])
		var tempMod = outputBuffer["yield"] % 1
		
		objResStats.configure(tempCost, outputBuffer["name"])
		$HBoxContainer/VBoxContainer2.add_child(objResStats)
		
		lab = Label.new()
		lab.rect_min_size = Vector2(0, 64)
		lab.text = str(tempMod*100) + "%"
		$HBoxContainer/VBoxContainer3.add_child(lab)
		
		margin = MarginContainer.new()
		margin.rect_min_size = Vector2(0, 64)
		$HBoxContainer/VBoxContainer.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer2.add_child(margin)
	margin = MarginContainer.new()
	margin.rect_min_size = Vector2(0, 64)
	$HBoxContainer/VBoxContainer3.add_child(margin)
	
	queue_sort()

func _on_Timer_timeout():
	get_tree().call_group("grpCtnSort", "resizeMyself")
