extends Control

onready var SideBarNode = get_node("../SideBarNode")

var objAddEntityButton = preload("res://Scenes/FactoryScene/objAddEntityButton.tscn")

var barType = "TopBar"
var barData = [["Processor",false],["Holder",false],["Enhancer",false],["Connector",false]]

func addEntityAddButton(nameID,entityType,subType):
	# Creating the Processor from template
	var newAddEntityButton = objAddEntityButton.instance() # Create new add Processor button from template as a variable
	newAddEntityButton.entityName = nameID # Give the node it's structure name
	newAddEntityButton.subType = subType # Give the node it's structure type
	newAddEntityButton.entityType = entityType # Give the node it's entityType type
	# Set texture based upon nameID
	newAddEntityButton.rect_min_size = Vector2(256,256)
	# Create the node as a child of grd (Grid)
	if entityType == "Structure":
		newAddEntityButton.texture = load("res://Assets/FactoryEntity/"+entityType+"/"+subType+"/img_"+nameID.to_lower()+".png")
		get_node("grd"+subType).add_child(newAddEntityButton)
	elif entityType == "Connector":
		newAddEntityButton.texture = load("res://Assets/FactoryEntity/"+entityType+"/"+subType+"/"+nameID+"/img_normal.png")
		get_node("grdConnector").add_child(newAddEntityButton)

func _ready():
	for Processor in MetaData.processorBank.values():
		addEntityAddButton(Processor["nameID"],"Structure","Processor")
	for Holder in MetaData.holderBank.values():
		addEntityAddButton(Holder["nameID"],"Structure","Holder")
	for conveyor in MetaData.enhancerBank.values():
		addEntityAddButton(conveyor["nameID"],"Structure","Enhancer")
	for conveyor in MetaData.conveyorBank.values():
		addEntityAddButton(conveyor["nameID"],"Connector","Conveyor")
	updateUI()

func move(target):
	var nodeTween = get_node("twnTopBar")
	nodeTween.interpolate_property(self, "rect_position", rect_position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

func updateUI():
	
	# Handle button images
	for btnData in barData:
		get_node("Buttons/tex"+btnData[0]).texture = load("res://Assets/UI/img_factory_nine_"+str(btnData[1]).to_lower()+".png")
		get_node("Buttons/tex"+btnData[0]+"/labOption").rect_position = int(btnData[1]) * Vector2(0,16)
	
	# Grey buttons if moving a structure
	if Globals.moveStructureMode == "moving":
		$Buttons.modulate = Color(0.3,0.3,0.3) # Grey out buttons
	else:
		$Buttons.modulate = Color(1,1,1) # Grey out buttons

func updateIsMenuOpen():
	Globals.isMenuOpen = false
	for btnData in barData:
		if btnData[1] == true:
			Globals.isMenuOpen = true
	
	if Globals.isMenuOpen == true:
		get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = true
		move(Vector2(0,384)) # Move the TopBar
		SideBarNode.move("off")
	else:
		get_node("../ctnFactoryViewport/vptFactoryScene").gui_disable_input = false
		move(Vector2(0,0)) # Move the TopBar
		SideBarNode.move("on")

func toggleButton(btnID):
	if Globals.moveStructureMode == "moving": # If we're not moving a structure
		return
	for iter_btnID in range(barData.size()):
		if iter_btnID == btnID:
			get_node("grd"+barData[iter_btnID][0]).rect_position = Vector2(0,-360)
			barData[iter_btnID][1] = not barData[btnID][1]
		else:
			get_node("grd"+barData[iter_btnID][0]).rect_position = Vector2(0,-1000)
			barData[iter_btnID][1] = false
	SideBarNode.untoggleButtons()
	updateIsMenuOpen()
	updateUI()

func untoggleButtons():
	for bar in barData:
		bar[1] = false
	updateIsMenuOpen()
	updateUI()

func _on_btnProcessorMenu_pressed():
	toggleButton(0)
func _on_btnHolderMenu_pressed():
	toggleButton(1)
func _on_btnEnhancerMenu_pressed():
	toggleButton(2)
func _on_btnConnectorMenu_pressed():
	toggleButton(3)






