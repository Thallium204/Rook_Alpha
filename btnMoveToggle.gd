extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texMoveToggle = get_node("texMoveToggle")

func _process(_delta):
	if Globals.moveStructureMode == "off":
		texMoveToggle.texture = load("res://Assets/Buttons/SideBar/img_move_toggle_off.png")
	elif Globals.moveStructureMode == "ready": # If we are ready to select the building to move
			texMoveToggle.texture = load("res://Assets/Buttons/SideBar/img_move_toggle_on1.png")
	elif Globals.moveStructureMode == "moving": # If we are ready to select the building to move
		texMoveToggle.texture = load("res://Assets/Buttons/SideBar/img_move_toggle_on2.png")

func _on_btnMoveToggle_released():
	if Globals.moveStructureMode == "off":
		Globals.moveStructureMode = "ready"
	elif Globals.moveStructureMode == "ready":
		Globals.moveStructureMode = "off"
	

