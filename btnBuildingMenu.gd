extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var labBuildingMenu = get_node("labBuildingMenu")

var textWhenClosed = "Build"
var textWhenOpen = "Close"

func _ready():
	labBuildingMenu.text = textWhenClosed

func _on_btnBuildingMenu_released():
	if Globals.isMenuOpen == true:
		labBuildingMenu.text = textWhenOpen
	else:
		labBuildingMenu.text = textWhenClosed
