extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var SideBarNode = get_node("../SideBarNode")

var barType = "TopBar"

func addStructureAddButton(nameID,structureType):
	# Creating the building from template
	var newStructureButton = templateNode.get_node("tmpAddStructure").duplicate() # Create new add building button from template as a variable
	newStructureButton.structureName = nameID # Give the node it's structure name
	newStructureButton.structureType = structureType # Give the node it's structure type
	# Set texture based upon nameID
	newStructureButton.texture = load("res://Assets/"+structureType+"/img_"+nameID.to_lower()+".png")
	newStructureButton.rect_min_size = Vector2(256,256)
	# Create the node as a child of grd (Grid)
	get_node("grd"+structureType).add_child(newStructureButton)

func _ready():
	for building in Globals.buildingBank:
		addStructureAddButton(building[0],"Building")
	for storage in Globals.storageBank:
		addStructureAddButton(storage[0],"Storage")
	for conveyor in Globals.conveyorBank:
		addStructureAddButton(conveyor[0],"Conveyor")

func move(target):
	var nodeTween = get_node("twnTopBar")
	nodeTween.interpolate_property(self, "rect_position", rect_position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

func _process(_delta):
	
	# Handle button images
	if Globals.addBuildingMenu == false:
		$btnBuildingMenu.normal = load("res://Assets/Buttons/"+barType+"/img_buildings_off.png")
	else:
		get_node("btnBuildingMenu").normal = load("res://Assets/Buttons/"+barType+"/img_buildings_on.png")
	
	if Globals.addStorageMenu == false:
		get_node("btnStorageMenu").normal = load("res://Assets/Buttons/"+barType+"/img_storage_off.png")
	else:
		get_node("btnStorageMenu").normal = load("res://Assets/Buttons/"+barType+"/img_storage_on.png")
	
	if Globals.addConveyorMenu == false:
		get_node("btnConveyorMenu").normal = load("res://Assets/Buttons/"+barType+"/img_conveyors_off.png")
	else:
		get_node("btnConveyorMenu").normal = load("res://Assets/Buttons/"+barType+"/img_conveyors_on.png")
	
	if Globals.autoCraft == false:
		get_node("btnAutocraftToggle").normal = load("res://Assets/Buttons/"+barType+"/img_autocraft_toggle_off.png")
	else:
		get_node("btnAutocraftToggle").normal = load("res://Assets/Buttons/"+barType+"/img_autocraft_toggle_on.png")
	
	# Grey buttons if moving a structure
	if Globals.moveStructureMode == "moving":
		$btnBuildingMenu.modulate = Color(0.3,0.3,0.3) # Grey out buildings button
		$btnStorageMenu.modulate = Color(0.3,0.3,0.3) # Grey out buildings button
		$btnConveyorMenu.modulate = Color(0.3,0.3,0.3) # Grey out buildings button
	else:
		$btnBuildingMenu.modulate = Color(1,1,1) # Grey out buildings button
		$btnStorageMenu.modulate = Color(1,1,1) # Grey out buildings button
		$btnConveyorMenu.modulate = Color(1,1,1) # Grey out buildings button
	

func updateIsMenuOpen():
	if Globals.addBuildingMenu == true or Globals.addStorageMenu == true or Globals.addConveyorMenu == true:
		Globals.isMenuOpen = true
	else:
		Globals.isMenuOpen = false
	
	if Globals.isMenuOpen == true:
		move(Vector2(0,384)) # Move the TopBar
		SideBarNode.move("off")
	else:
		move(Vector2(0,0)) # Move the TopBar
		SideBarNode.move("on")

func _on_btnBuildingMenu_pressed():
	if Globals.moveStructureMode != "moving": # If we're not moving a structure
		$grdBuilding.rect_position = Vector2(0,-360)
		Globals.addBuildingMenu = not Globals.addBuildingMenu
		Globals.addStorageMenu = false
		Globals.addConveyorMenu = false
		$grdStorage.rect_position = Vector2(0,-1000)
		$grdConveyor.rect_position = Vector2(0,-1000)
		SideBarNode.untoggleButtons()
		updateIsMenuOpen()
	
func _on_btnStorageMenu_pressed():
	if Globals.moveStructureMode != "moving": # If we're not moving a structure
		$grdStorage.rect_position = Vector2(0,-360)
		Globals.addStorageMenu = not Globals.addStorageMenu
		Globals.addBuildingMenu = false
		Globals.addConveyorMenu = false
		$grdBuilding.rect_position = Vector2(0,-1000)
		$grdConveyor.rect_position = Vector2(0,-1000)
		SideBarNode.untoggleButtons()
		updateIsMenuOpen()

func _on_btnConveyorMenu_pressed():
	if Globals.moveStructureMode != "moving": # If we're not moving a structure
		$grdConveyor.rect_position = Vector2(0,-360)
		Globals.addConveyorMenu = not Globals.addConveyorMenu
		Globals.addBuildingMenu = false
		Globals.addStorageMenu = false
		$grdBuilding.rect_position = Vector2(0,-1000)
		$grdStorage.rect_position = Vector2(0,-1000)
		SideBarNode.untoggleButtons()
		updateIsMenuOpen()

func _on_btnAutocraftToggle_pressed():
	if Globals.autoCraft == true:
		Globals.autoCraft = false
	else:
		Globals.autoCraft = true
