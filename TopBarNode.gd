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
	get_node("scr"+structureType+"/grdStructure").add_child(newStructureButton)

func _ready():
	for building in Globals.buildingBank:
		addStructureAddButton(building[0],"Building")
	for storage in Globals.storageBank:
		addStructureAddButton(storage[0],"Storage")

func move(target):
	var nodeTween = templateNode.get_node("tmpMenu")
	nodeTween.interpolate_property(self, "rect_position", rect_position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

func _process(_delta):
	
	# Handle Build Menu movement
	if Globals.isMenuOpen == false:
		move(Vector2(0,0)) # Move the TopBar
		SideBarNode.move(Vector2(1080,128)) # Move the SideBar
	else:
		move(Vector2(0,384)) # Move the TopBar
		SideBarNode.move(Vector2(1080,128+384)) # Move the SideBar
	
	# Handle button images
	if Globals.addBuildingMode == false:
		get_node("btnBuildingMenu").normal = load("res://Assets/Buttons/"+barType+"/img_buildings_off.png")
	else:
		get_node("btnBuildingMenu").normal = load("res://Assets/Buttons/"+barType+"/img_buildings_on.png")
	
	if Globals.addStorageMode == false:
		get_node("btnStorageMenu").normal = load("res://Assets/Buttons/"+barType+"/img_storage_off.png")
	else:
		get_node("btnStorageMenu").normal = load("res://Assets/Buttons/"+barType+"/img_storage_on.png")
	
	if Globals.addConveyorMode == false:
		get_node("btnConveyorMenu").normal = load("res://Assets/Buttons/"+barType+"/img_conveyors_off.png")
	else:
		get_node("btnConveyorMenu").normal = load("res://Assets/Buttons/"+barType+"/img_conveyors_on.png")
	
	if Globals.autoCraft == false:
		get_node("btnAutocraftToggle").normal = load("res://Assets/Buttons/"+barType+"/img_autocraft_toggle_off.png")
	else:
		get_node("btnAutocraftToggle").normal = load("res://Assets/Buttons/"+barType+"/img_autocraft_toggle_on.png")
	
	# Ser isMenuOpen
	if Globals.addBuildingMode == true or Globals.addStorageMode == true or Globals.addConveyorMode == true:
		Globals.isMenuOpen = true
	else:
		Globals.isMenuOpen = false

func _on_btnBuildingMenu_pressed():
	$scrBuilding.rect_position = Vector2(0,-360)
	Globals.addBuildingMode = not Globals.addBuildingMode
	Globals.addStorageMode = false
	Globals.addConveyorMode = false
	$scrStorage.rect_position = Vector2(0,-1000)
	$scrConveyor.rect_position = Vector2(0,-1000)
	SideBarNode.untoggleButtons()
	
func _on_btnStorageMenu_pressed():
	$scrStorage.rect_position = Vector2(0,-360)
	Globals.addStorageMode = not Globals.addStorageMode
	Globals.addBuildingMode = false
	Globals.addConveyorMode = false
	$scrBuilding.rect_position = Vector2(0,-1000)
	$scrConveyor.rect_position = Vector2(0,-1000)
	SideBarNode.untoggleButtons()

func _on_btnConveyorMenu_pressed():
	$scrConveyor.rect_position = Vector2(0,-360)
	Globals.addConveyorMode = not Globals.addConveyorMode
	Globals.addBuildingMode = false
	Globals.addStorageMode = false
	$scrBuilding.rect_position = Vector2(0,-1000)
	$scrStorage.rect_position = Vector2(0,-1000)
	SideBarNode.untoggleButtons()

func _on_btnAutocraftToggle_pressed():
	if Globals.autoCraft == true:
		Globals.autoCraft = false
	else:
		Globals.autoCraft = true
