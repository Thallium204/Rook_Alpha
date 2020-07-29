extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texMoveToggle = get_node("texMoveToggle")

func _process(_delta):
	if Globals.moveBuildingsMode == true:
		if Globals.movePair[0] == null: # If we are on our first selection
			texMoveToggle.texture = load("res://Sprites/Buttons/SideBar/img_move_toggle_on1.png")
		else:# If we are on our second selection
			texMoveToggle.texture = load("res://Sprites/Buttons/SideBar/img_move_toggle_on2.png")
	else:
		texMoveToggle.texture = load("res://Sprites/Buttons/SideBar/img_move_toggle_off.png")

func _on_btnMoveToggle_released():
	if Globals.moveBuildingsMode == false and Globals.addConveyorMode == false:
		Globals.moveBuildingsMode = true
	else:
		Globals.moveBuildingsMode = false

