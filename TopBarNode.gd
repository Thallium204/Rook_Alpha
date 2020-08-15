extends Control

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")
onready var SideBarNode = get_node("../SideBarNode")

var barType = "TopBar"
var barData = [["Processor",false],["Holder",false],["Enhancer",false],["Connector",false]]
var dict = {true:"on",false:"off"}

func addStructureAddButton(nameID,structureType):
	# Creating the Processor from template
	var newStructureButton = templateNode.get_node("tmpAddStructure").duplicate() # Create new add Processor button from template as a variable
	newStructureButton.structureName = nameID # Give the node it's structure name
	newStructureButton.structureType = structureType # Give the node it's structure type
	# Set texture based upon nameID
	newStructureButton.texture = load("res://Assets/FactoryEntity/Structure/"+structureType+"/img_"+nameID.to_lower()+".png")
	newStructureButton.rect_min_size = Vector2(256,256)
	# Create the node as a child of grd (Grid)
	get_node("grd"+structureType).add_child(newStructureButton)

func _ready():
	for Processor in Globals.processorBank:
		addStructureAddButton(Processor[0],"Processor")
	for Holder in Globals.holderBank:
		addStructureAddButton(Holder[0],"Holder")
#	for conveyor in Globals.enhancerBank:
#		addStructureAddButton(conveyor[0],"Enhancer")

func move(target):
	var nodeTween = get_node("twnTopBar")
	nodeTween.interpolate_property(self, "rect_position", rect_position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

func _process(_delta):
	
	# Handle button images
	for btnData in barData:
		get_node("btn"+btnData[0]+"Menu").normal = load("res://Assets/Buttons/"+barType+"/img_"+btnData[0].to_lower()+"_"+dict[btnData[1]]+".png")
	
	# Grey buttons if moving a structure
	if Globals.moveStructureMode == "moving":
		$btnProcessorMenu.modulate = Color(0.3,0.3,0.3) # Grey out Processors button
		$btnHolderMenu.modulate = Color(0.3,0.3,0.3) # Grey out Processors button
		$btnEnhancerMenu.modulate = Color(0.3,0.3,0.3) # Grey out Processors button
	else:
		$btnProcessorMenu.modulate = Color(1,1,1) # Grey out Processors button
		$btnHolderMenu.modulate = Color(1,1,1) # Grey out Processors button
		$btnEnhancerMenu.modulate = Color(1,1,1) # Grey out Processors button

func updateIsMenuOpen():
	Globals.isMenuOpen = false
	for btnData in barData:
		if btnData[1] == true:
			Globals.isMenuOpen = true
	
	if Globals.isMenuOpen == true:
		move(Vector2(0,384)) # Move the TopBar
		SideBarNode.move("off")
	else:
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

func _on_btnProcessorMenu_pressed():
	toggleButton(0)
func _on_btnHolderMenu_pressed():
	toggleButton(1)
func _on_btnEnhancerMenu_pressed():
	toggleButton(2)
func _on_btnConnectorMenu_pressed():
	toggleButton(3)

func _on_btnAutocraftToggle_pressed():
	if Globals.autoCraft == true:
		Globals.autoCraft = false
	else:
		Globals.autoCraft = true






