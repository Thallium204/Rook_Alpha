extends TouchScreenButton

var infoIsDisplayed = true

func _ready():
	_on_btnInfoToggle_released()

func _on_btnInfoToggle_released():
	if infoIsDisplayed == false:
		infoIsDisplayed = true
		get_node("labInfoToggle").set("custom_colors/font_color",Color(0,1,0))
	else:
		infoIsDisplayed = false
		get_node("labInfoToggle").set("custom_colors/font_color",Color(1,0,0))
