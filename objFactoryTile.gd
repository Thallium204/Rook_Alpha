extends TouchScreenButton

onready var Globals = null
onready var ctrlFactoryFloor = null

var entityTile = null # {"row":0,"col":0}The indexes for the pointerArray
var fatherNode = null

var directionDict = { [0,0]:"" , [-1, 0]:"U" , [ 0, 1]:"R" , [ 1, 0]:"D" , [ 0,-1]:"L" }
var inv_directionDict = { "":"" , "D":"U" , "L":"R" , "U":"D" , "R":"L" }

# NOTE: You 'enter' the new area BEFORE 'exiting' the old one (if there is no gap between the areas)

func updatePosition():
	position = ctrlFactoryFloor.tileSize*Vector2(entityTile["col"],entityTile["row"])

func _ready():
	Globals = get_tree().get_root().get_node("Game/Globals")
	ctrlFactoryFloor = Globals.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")

func _process(_delta):
	
	if fatherNode != null:
		modulate = Color(1,1,1,0)
	else:
		modulate = Color(1,1,1,0.2)

# Area2D Signals

# When the mouse enters our Area
func _on_areaTile_mouse_entered():
	
	if Globals.drawConnectorMode == "moving":
		if fatherNode == null:
			Globals.initialseConnectorData(entityTile)
		# We check again because initialseConnectorData can change our fatherNode
		if fatherNode != null:
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
				if entityTile["row"]+row in range( 0 , ctrlFactoryFloor.pointerArray.size() ):
					if entityTile["col"]+col in range( 0 , ctrlFactoryFloor.pointerArray[0].size() ):
						if ctrlFactoryFloor.pointerArray[entityTile["row"]+row][entityTile["col"]+col] == otherTileArea:
							direction = [row,col]
	if forward == true:
		return directionDict[direction]
	else:
		return inv_directionDict[directionDict[direction]]


