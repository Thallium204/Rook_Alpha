extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var FactorySceneNode = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/FactorySceneNode")
onready var ctrlFactoryFloor = FactorySceneNode.get_node("ctrlFactoryFloor")

var gridVector = [0,0]

func check_isTileFree(masterTile):
	
	# Are we above a free tile
	if ctrlFactoryFloor.pointerArray[ masterTile[0]+gridVector[0] ][ masterTile[1]+gridVector[1] ] == null:
		normal = load("res://Assets/Menu/img_menu_yes.png")
		return true
	else: # Are we above a taken tile
		normal = load("res://Assets/Menu/img_menu_no.png")
		return false
