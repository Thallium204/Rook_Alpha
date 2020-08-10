extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

onready var btnInfo = get_node("btnInfoToggle")
onready var texInfoBar = get_node("texInfoBar")
onready var btnMove = get_node("btnMoveToggle")
onready var btnDelete = get_node("btnDeleteToggle")
onready var btnConnect = get_node("btnConnectToggle")

onready var texInfoRef = texInfoBar.duplicate()

var barType = "SideBar"

func _process(_delta):
	
	# Handle UI
	btnMove.modulate = Color(1,1,1)
	btnConnect.modulate = Color(1,1,1)
	btnDelete.modulate = Color(1,1,1)
	
	# Handle Info
	if Globals.displayInfoMode == false:
		btnInfo.normal = load("res://Assets/Buttons/"+barType+"/img_info_off.png")
		texInfoBar.visible = false
	else:
		btnInfo.normal = load("res://Assets/Buttons/"+barType+"/img_info_on.png")
		texInfoBar.visible = true
	
	# Handle Moving
	btnMove.normal = load("res://Assets/Buttons/"+barType+"/img_move_"+Globals.moveStructureMode+".png")
	if Globals.moveStructureMode == "moving":
		btnConnect.modulate = Color(0.3,0.3,0.3) # Grey out connect button
		btnDelete.modulate = Color(0.3,0.3,0.3) # Grey out delete button
	
	# Handle Connect
	btnConnect.normal = load("res://Assets/Buttons/"+barType+"/img_connect_"+Globals.drawConveyorMode+".png")
	if Globals.drawConveyorMode == "moving":
		btnMove.modulate = Color(0.3,0.3,0.3) # Grey out move button
		btnDelete.modulate = Color(0.3,0.3,0.3) # Grey out delete button
	
	# Handle Delete
	if Globals.deleteStructureMode == false:
		btnDelete.normal = load("res://Assets/Buttons/"+barType+"/img_delete_off.png")
	else:
		btnDelete.normal = load("res://Assets/Buttons/"+barType+"/img_delete_on.png")

func move(mode):
	var nodeTween = get_node("twnSideBar")
	if mode == "off": # If we're moving to be in view
		nodeTween.interpolate_property(self, "rect_position", rect_position,  Vector2(1080,128) + Vector2(128,0), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		nodeTween.start()
		nodeTween.interpolate_property(texInfoBar, "rect_position", texInfoBar.rect_position,  texInfoRef.rect_position + Vector2(-128,texInfoRef.rect_size[1]+16), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		nodeTween.start()
	elif mode == "on":
		nodeTween.interpolate_property(self, "rect_position", rect_position,  Vector2(1080,128), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		nodeTween.start()
		nodeTween.interpolate_property(texInfoBar, "rect_position", texInfoBar.rect_position,  texInfoRef.rect_position, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		nodeTween.start()

func untoggleButtons():
	Globals.moveStructureMode = "off"
	Globals.drawConveyorMode = "off"
	Globals.deleteStructureMode = false

func _on_btnInfoToggle_pressed():
	if Globals.displayInfoMode == false: # Toggle info mode
		Globals.displayInfoMode = true
	else:
		Globals.displayInfoMode = false

func _on_btnMoveToggle_pressed():
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.moveStructureMode == "off" and Globals.drawConveyorMode != "moving": # If move mode is "off"
			Globals.deleteStructureMode = false # Deactivate Delete mode
			Globals.drawConveyorMode = "off" # Deactivate conveyor mode
			Globals.moveStructureMode = "ready" # Set move mode to "ready"
		elif Globals.moveStructureMode == "ready":  # If move mode is "ready"
			Globals.moveStructureMode = "off" # Set move mode to "off"

func _on_btnConnectToggle_pressed():
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.drawConveyorMode == "off" and Globals.moveStructureMode != "moving":
			Globals.moveStructureMode = "off" # Deactivate move mode
			Globals.deleteStructureMode = false # Deactivate Delete mode
			Globals.drawConveyorMode = "ready" # Set move mode to "ready"
		elif Globals.drawConveyorMode == "ready":  # If move mode is "ready"
			Globals.drawConveyorMode = "off" # Set move mode to "off"

func _on_btnDeleteToggle_pressed():
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.moveStructureMode != "moving" and Globals.drawConveyorMode != "moving": # Don't allow deleting in "moving" mode
			Globals.moveStructureMode = "off" # Deactivate move mode
			Globals.drawConveyorMode = "off" # Deactivate conveyor mode
			if Globals.deleteStructureMode == false: # Toggle delete mode
				Globals.deleteStructureMode = true
			else:
				Globals.deleteStructureMode = false
