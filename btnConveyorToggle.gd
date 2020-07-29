extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var texConveyorToggle = get_node("texConveyorToggle")
	
func _process(_delta):
	if Globals.addConveyorMode == true:
		if Globals.conveyorPair[0] == null: # If we are on our first selection
			texConveyorToggle.texture = load("res://Sprites/Buttons/TopBar/img_connect_toggle_on1.png")
		else:# If we are on our second selection
			texConveyorToggle.texture = load("res://Sprites/Buttons/TopBar/img_connect_toggle_on2.png")
	else:
		texConveyorToggle.texture = load("res://Sprites/Buttons/TopBar/img_connect_toggle_off.png")

func _on_btnConveyorToggle_released():
	if Globals.addConveyorMode == false:
		Globals.addConveyorMode = true
	else:
		Globals.addConveyorMode = false
		Globals.conveyorPair = [null,null]
