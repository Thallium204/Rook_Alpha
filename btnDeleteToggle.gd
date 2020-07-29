extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texDeleteToggle = get_node("texDeleteToggle")

func _process(_delta):
	if Globals.deleteBuildingsMode == true:
		texDeleteToggle.texture = load("res://Sprites/Buttons/SideBar/img_delete_toggle_on.png")
	else:
		texDeleteToggle.texture = load("res://Sprites/Buttons/SideBar/img_delete_toggle_off.png")




func _on_btnDeleteToggle_released():
	
	if Globals.deleteBuildingsMode == false and Globals.addConveyorMode == false:
		Globals.deleteBuildingsMode = true
	else:
		Globals.deleteBuildingsMode = false
