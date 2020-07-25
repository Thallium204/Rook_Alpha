extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")

func _ready():
	_on_btnMoveToggle_released()

func _process(_delta):
	if Globals.moveBuildingsMode == true:
		if Globals.movePair[0] == null: # If we are on our first selection
			get_node("labMoveToggle").text = "SWAP?"
		else:# If we are on our second selection
			get_node("labMoveToggle").text = "WITH?"

func _on_btnMoveToggle_released():
	if Globals.moveBuildingsMode == false and Globals.addConveyorMode == false:
		Globals.moveBuildingsMode = true
		get_node("labMoveToggle").set("custom_colors/font_color",Color(0,1,0))
	else:
		Globals.moveBuildingsMode = false
		get_node("labMoveToggle").set("custom_colors/font_color",Color(1,1,1))
		get_node("labMoveToggle").text = "Move"

