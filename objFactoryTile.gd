extends TouchScreenButton

onready var Globals = null
onready var ctrlFactoryFloor = null

var repeatEnteredList = [] 	# List of area nodes we constantly call the "entered" function for
var entityTile = null # {"row":0,"col":0}The indexes for the pointerArray
var fatherNode = null

var directionDict = {
	[0,0]:"",
	[-1, 0]:"U",
	[ 0, 1]:"R",
	[ 1, 0]:"D",
	[ 0,-1]:"L"
	}

var inv_directionDict = { "":"" , "D":"U" , "L":"R" , "U":"D" , "R":"L" }

# NOTE: You 'enter' the new area BEFORE 'exiting' the old one (if there is no gap between the areas)

func reparent(newParent):
	get_parent().remove_child(self) # Remove ourself from our current parent
	newParent.add_child(newParent) # Add ourself as child to new parent

func updatePosition():
	position = ctrlFactoryFloor.tileSize*Vector2(entityTile["col"],entityTile["row"])

func _ready():
	Globals = get_tree().get_root().get_node("Game/Globals")
	ctrlFactoryFloor = Globals.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")

func _process(_delta):
	# Treat the trackArea's like they are entering every frame
	for area in repeatEnteredList:
		_on_areaTile_area_entered(area)
	
	if fatherNode != null:
		modulate = Color(1,1,1,0.3)
	else:
		modulate = Color(0.3,0.3,0.3,0.3)

# Area2D Signals

# When a node's Area enters our Area
func _on_areaTile_area_entered(area):
	
	if fatherNode == null:
		return
	
	var resourceNode = area.get_parent()
	
	if fatherNode.entityType == "Structure":
	
		if "Detect" in area.name: # If a resource's outer area comes into contact with a structure
			fatherNode.inputResource(resourceNode) # Let the structure node handle it

# When a node's Area exits our Area
func _on_areaTile_area_exited(_area):
	pass

# When a node's Area enterd our Center Area
func _on_areaCenter_area_entered(area):
	
	if "Tile" in area.name or "Center" in area.name:
		return
	
	var resourceNode = area.get_parent()
	
	if fatherNode == null:
		resourceNode.queue_free()
		return
	
	if fatherNode.entityType == "Connector":
	
		if "Inner" in area.name: # If a resource's inner area comes into contact with a conveyor
			fatherNode.pointResource(resourceNode) # Let the conveyor node handle it

# When the mouse enters our Area
func _on_areaTile_mouse_entered():
	
	if Globals.drawConnectorMode == "moving":
		if fatherNode == null:
			Globals.initialseConnectorData(entityTile)
		fatherNode.addInput(Globals.lastTileArea,getDirectionOfTileArea(Globals.lastTileArea,true))
		Globals.lastTileArea = self
	
	if fatherNode == null:
		return
	
	fatherNode.updateUI()

# When the mouse exits our Area
func _on_areaTile_mouse_exited():
	
	if fatherNode == null:
		return
	if Globals.drawConnectorMode == "moving":
		fatherNode.addOutput(Globals.lastTileArea,getDirectionOfTileArea(Globals.lastTileArea,true))
	fatherNode.updateUI()


# TouchScreenButton Signals

# When the mouse presses our Button
func _on_objFactoryTile_pressed():
	
	if Globals.drawConnectorMode == "ready":
		Globals.drawConnectorMode = "moving"
		if fatherNode == null:
			Globals.initialseConnectorData(entityTile)
		Globals.lastTileArea = self
	
	if fatherNode == null:
		return
	
	fatherNode.onPressed(entityTile)

# When the mouse releases our Button
func _on_objFactoryTile_released():
	
	if fatherNode == null:
		if Globals.drawConnectorMode == "moving":
			Globals.lastTileArea = null
			Globals.drawConnectorMode = "ready"
		return
	
	fatherNode.onReleased(entityTile)

func getDirectionOfTileArea(otherTileArea,forward):
	
	var direction = [0,0]
	for row in [-1,0,1]:
		for col in [-1,0,1]:
			if row == 0 or col == 0:
				if ctrlFactoryFloor.pointerArray[entityTile["row"]+row][entityTile["col"]+col] == otherTileArea:
					direction = [row,col]
	if forward == true:
		return directionDict[direction]
	else:
		return inv_directionDict[directionDict[direction]]


