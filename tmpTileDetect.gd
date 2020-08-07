extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var vptFactoryScene = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene")
onready var ctrlFactoryFloor = vptFactoryScene.get_node("ctrlFactoryFloor")

var gridVector = [0,0]
var structureNode = null

func check_isTileFree(masterTile):
	
	# Are we above a free tile
	if ctrlFactoryFloor.pointerArray[ masterTile[0]+gridVector[0] ][ masterTile[1]+gridVector[1] ] == null:
		return true
	else: # Are we above a taken tile
		return false

# If the user just pressed our tile
func _on_tmpTileDetect_pressed():
	structureNode.onStructure_Pressed(self)

# If the user just released our tile
func _on_tmpTileDetect_released():
	structureNode.onStructure_Released(self)
