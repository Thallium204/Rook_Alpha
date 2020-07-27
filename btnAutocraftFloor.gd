extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texAutocraftToggle = get_node("texAutocraftToggle")

func _ready():
	_on_btnAutocraftToggle_released()

func _process(_delta):
	if Globals.autoCraft == true:
		texAutocraftToggle.texture = load("res://Sprites/Buttons/TopBar/img_autocraft_toggle_on.png")
	else:
		texAutocraftToggle.texture = load("res://Sprites/Buttons/TopBar/img_autocraft_toggle_off.png")


func _on_btnAutocraftToggle_released():
	if Globals.autoCraft == false and Globals.addConveyorMode == false:
		Globals.autoCraft = true
	else:
		Globals.autoCraft = false
