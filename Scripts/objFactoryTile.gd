extends TouchScreenButton

onready var Menus = null
onready var texInfoBar = null
onready var ctrlFactoryFloor = null
onready var ioIndicators = $ioIndicators.get_children()

var entityTile = null # {"row":0,"col":0}The indexes for the pointerArray
var fatherNode = null

var isReleasedValid = false
var connectedDirections = []

# NOTE: the mouse 'enters' a new area BEFORE 'exiting' the old one (if there is no gap between the areas)

func _ready():
	Menus = get_tree().get_root().get_node("Game/Menus")
	texInfoBar = Menus.get_node("FactoryNode/SideBarNode/texInfoBar")
	ctrlFactoryFloor = Menus.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
	updateUI()

func setFatherNode(node):
	fatherNode = node
	updateUI()

func updateUI():
	
	if fatherNode == null:
		$texTile.modulate = Color(1,1,1,0.2)
		$texBacking.visible = false
		$ioIndicators.visible = false
		$texFill.visible = false
		return
	else:
		$texTile.modulate = Color(1,1,1,0)
		$texBacking.visible = true
		if fatherNode.entityType == "Connector":
			$ioIndicators.visible = false
			return
		else:
			$ioIndicators.visible = true
	
	for spr in ioIndicators:
		spr.visible = false
	
	for ioTilePos in connectedDirections:
		$ioIndicators.get_node("spr"+str(ioTilePos)).visible = true
	
	if fatherNode == texInfoBar.infoNode and Globals.displayInfoMode == true and fatherNode != null:
		$texFill.modulate = Color(0.5,0.5,0.5,0.5)
	else:
		$texFill.modulate = Color(1,1,1,0)

func drawConnector():
	ctrlFactoryFloor.addConnector(entityTile)

func updatePosition():
	position = ctrlFactoryFloor.tileSize*Vector2(entityTile["col"],entityTile["row"])



# Area2D Signals

# When the mouse enters our Area
func _on_areaTile_mouse_entered():
	
	if fatherNode == null:
		if Globals.drawConnectorMode == "moving":
			drawConnector()
		return
	
	fatherNode.updateUI()

# When the mouse exits our Area
func _on_areaTile_mouse_exited():
	
	isReleasedValid = false
	
	if fatherNode == null:
		return
	
	fatherNode.updateUI()



# TouchScreenButton Signals

# When the mouse presses our Button
func _on_objFactoryTile_pressed():
	
	isReleasedValid = true
	
	if Globals.drawConnectorMode == "ready":
		Globals.drawConnectorMode = "moving"
		_on_areaTile_mouse_entered()
	
	if fatherNode == null:
		return
	
	fatherNode.onPressed(entityTile)

# When the mouse releases our Button
func _on_objFactoryTile_released():
	
	if Globals.drawConnectorMode == "moving":
		Globals.drawConnectorMode = "ready"
	
	if fatherNode == null or not(isReleasedValid):
		return
	
	fatherNode.onReleased(entityTile)



