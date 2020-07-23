extends TouchScreenButton

onready var Globals = get_tree().get_root().get_node("Game/Globals")

func _ready():
	_on_btnConveyorToggle_released()
	
func _process(_delta):
	if Globals.addConveyorMode == true:
		if Globals.conveyorPair[0] == null: # If we are on our first selection
			get_node("labConveyorToggle").text = "Extract?"
		else:# If we are on our second selection
			get_node("labConveyorToggle").text = "Insert?"
			

func _on_btnConveyorToggle_released():
	if Globals.addConveyorMode == false:
		Globals.addConveyorMode = true
		get_node("labConveyorToggle").set("custom_colors/font_color",Color(0,1,0))
	else:
		Globals.addConveyorMode = false
		Globals.conveyorPair = [null,null]
		get_node("labConveyorToggle").set("custom_colors/font_color",Color(1,1,1))
		get_node("labConveyorToggle").text = "Conveyor"
