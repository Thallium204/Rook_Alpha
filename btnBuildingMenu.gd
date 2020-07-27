extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texBuildingToggle = get_node("texBuildingToggle")


func _on_btnBuildingMenu_released():
	if Globals.isMenuOpen == true:
		texBuildingToggle.texture = load("res://Sprites/Buttons/TopBar/img_build_toggle_on.png")
	else:
		texBuildingToggle.texture = load("res://Sprites/Buttons/TopBar/img_build_toggle_off.png")
