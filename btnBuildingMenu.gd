extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texBuildingToggle = get_node("texBuildingToggle")


func _on_btnBuildingMenu_released():
	pass


func _on_btnBuildingMenu_pressed():
	if Globals.isMenuOpen == true:
		texBuildingToggle.texture = load("res://Assets/Buttons/TopBar/img_build_toggle_on.png")
	else:
		texBuildingToggle.texture = load("res://Assets/Buttons/TopBar/img_build_toggle_off.png")
