extends Control

onready var btnInfo = get_node("btnInfoToggle")
onready var texInfoBar = get_node("texInfoBar")
onready var btnMove = get_node("btnMoveToggle")
onready var btnDelete = get_node("btnDeleteToggle")
onready var btnConnect = get_node("btnConnectToggle")
onready var btnAutocraft = get_node("btnAutocraftToggle")

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
	if Globals.drawConnector["nameID"] != "":
		if Inventory.entityInv[ Globals.drawConnector["nameID"] ] == 0:
			Globals.drawConnector["nameID"] = ""
		btnConnect.get_node("texConnector").modulate = Color(1,1,1,1)
		btnConnect.get_node("texConnector").texture = load("res://Assets/FactoryEntity/Connector/"+Globals.drawConnector["connectorType"]+"/"+Globals.drawConnector["nameID"]+"/img_normal.png")
	else:
		btnConnect.get_node("texConnector").modulate = Color(1,1,1,0)
	btnConnect.normal = load("res://Assets/Buttons/"+barType+"/img_connect_"+Globals.drawConnectorMode+".png")
	if Globals.drawConnectorMode == "moving":
		btnMove.modulate = Color(0.3,0.3,0.3) # Grey out move button
		btnDelete.modulate = Color(0.3,0.3,0.3) # Grey out delete button
	
	# Handle Delete
	if Globals.deleteStructureMode == false:
		btnDelete.normal = load("res://Assets/Buttons/"+barType+"/img_delete_off.png")
	else:
		btnDelete.normal = load("res://Assets/Buttons/"+barType+"/img_delete_on.png")#
	
	# Handle Autocraft
	if Globals.autoCraft == false:
		btnAutocraft.normal = load("res://Assets/Buttons/"+barType+"/img_autocraft_off.png")
	else:
		btnAutocraft.normal = load("res://Assets/Buttons/"+barType+"/img_autocraft_on.png")

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
	Globals.drawConnectorMode = "off"
	Globals.deleteStructureMode = false


func _on_btnInfoToggle_pressed():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = true
	if Globals.displayInfoMode == false: # Toggle info mode
		Globals.displayInfoMode = true
	else:
		Globals.displayInfoMode = false

func _on_btnInfoToggle_released():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = false


func _on_btnMoveToggle_pressed():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = true
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.moveStructureMode == "off" and Globals.drawConnectorMode != "moving": # If move mode is "off"
			Globals.deleteStructureMode = false # Deactivate Delete mode
			Globals.drawConnectorMode = "off" # Deactivate conveyor mode
			Globals.moveStructureMode = "ready" # Set move mode to "ready"
		elif Globals.moveStructureMode == "ready":  # If move mode is "ready"
			Globals.moveStructureMode = "off" # Set move mode to "off"

func _on_btnMoveToggle_released():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = false

func _on_btnConnectToggle_pressed():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = true
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.drawConnectorMode == "off" and Globals.moveStructureMode != "moving":
			Globals.moveStructureMode = "off" # Deactivate move mode
			Globals.deleteStructureMode = false # Deactivate Delete mode
			Globals.drawConnectorMode = "ready" # Set move mode to "ready"
		elif Globals.drawConnectorMode == "ready":  # If move mode is "ready"
			Globals.drawConnectorMode = "off" # Set move mode to "off"

func _on_btnConnectToggle_released():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = false

func _on_btnDeleteToggle_pressed():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = true
	if Globals.isMenuOpen == false: # If the menu isn't open
		if Globals.moveStructureMode != "moving" and Globals.drawConnectorMode != "moving": # Don't allow deleting in "moving" mode
			Globals.moveStructureMode = "off" # Deactivate move mode
			Globals.drawConnectorMode = "off" # Deactivate conveyor mode
			if Globals.deleteStructureMode == false: # Toggle delete mode
				Globals.deleteStructureMode = true
			else:
				Globals.deleteStructureMode = false

func _on_btnDeleteToggle_released():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = false


func _on_btnAutocraftToggle_pressed():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = true
	if Globals.autoCraft == false: # Toggle info mode
		Globals.autoCraft = true
	else:
		Globals.autoCraft = false

func _on_btnAutocraftToggle_released():
	get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = false
