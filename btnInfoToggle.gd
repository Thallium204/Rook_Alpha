extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texInfoToggle = get_node("texInfoToggle")

func _process(_delta):
	if Globals.infoIsDisplayed == true:
		texInfoToggle.texture = load("res://Sprites/Buttons/SideBar/img_info_toggle_on.png")
	else:
		texInfoToggle.texture = load("res://Sprites/Buttons/SideBar/img_info_toggle_off.png")




func _on_btnInfoToggle_released():
	if Globals.infoIsDisplayed == false:
		Globals.infoIsDisplayed = true
	else:
		Globals.infoIsDisplayed = false
