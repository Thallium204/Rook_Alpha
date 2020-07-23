extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")

func _ready():
	_on_btnInfoToggle_released()

func _on_btnInfoToggle_released():
	if Globals.infoIsDisplayed == false:
		Globals.infoIsDisplayed = true
		get_node("labInfoToggle").set("custom_colors/font_color",Color(0,1,0))
	else:
		Globals.infoIsDisplayed = false
		get_node("labInfoToggle").set("custom_colors/font_color",Color(1,0,0))
