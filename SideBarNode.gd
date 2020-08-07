extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

var barType = "SideBar"

func _process(_delta):
	
	# Handle button images
	if Globals.infoIsDisplayed == false:
		get_node("btnInfoToggle").normal = load("res://Assets/Buttons/"+barType+"/img_info_toggle_off.png")
	else:
		get_node("btnInfoToggle").normal = load("res://Assets/Buttons/"+barType+"/img_info_toggle_on.png")
	
	get_node("btnDeleteToggle").modulate = Color(1,1,1)
	if Globals.moveStructureMode == "off":
		get_node("btnMoveToggle").normal = load("res://Assets/Buttons/"+barType+"/img_move_toggle_off.png")
	elif Globals.moveStructureMode == "ready": # If we are ready to select the building to move
		get_node("btnMoveToggle").normal = load("res://Assets/Buttons/"+barType+"/img_move_toggle_on1.png")
	elif Globals.moveStructureMode == "moving": # If we are ready to select the building to move
		get_node("btnMoveToggle").normal = load("res://Assets/Buttons/"+barType+"/img_move_toggle_on2.png")
		get_node("btnDeleteToggle").modulate = Color(0.3,0.3,0.3)
	
	if Globals.deleteStructureMode == false:
		get_node("btnDeleteToggle").normal = load("res://Assets/Buttons/"+barType+"/img_delete_toggle_off.png")
	else:
		get_node("btnDeleteToggle").normal = load("res://Assets/Buttons/"+barType+"/img_delete_toggle_on.png")

func move(target):
	var nodeTween = templateNode.get_node("tmpMenu")
	nodeTween.interpolate_property(self, "rect_position", rect_position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

func untoggleButtons():
	Globals.moveStructureMode = "off"
	Globals.deleteStructureMode = false

func _on_btnInfoToggle_pressed():
	if Globals.infoIsDisplayed == false: # Toggle info mode
		Globals.infoIsDisplayed = true
	else:
		Globals.infoIsDisplayed = false

func _on_btnMoveToggle_pressed():
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.moveStructureMode == "off": # If move mode is "off"
			Globals.deleteStructureMode = false # Deactivate Delete mode
			Globals.moveStructureMode = "ready" # Set move mode to "ready"
		elif Globals.moveStructureMode == "ready":  # If move mode is "ready"
			Globals.moveStructureMode = "off" # Set move mode to "off"

func _on_btnDeleteToggle_pressed():
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.moveStructureMode != "moving": # Don't allow deleting in "moving" mode
			Globals.moveStructureMode = "off" # Deactivate move mode
			if Globals.deleteStructureMode == false: # Toggle delete mode
				Globals.deleteStructureMode = true
			else:
				Globals.deleteStructureMode = false
