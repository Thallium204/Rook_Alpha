extends TouchScreenButton

onready var labAddBuilding = get_node("labAddBuilding")

func _on_btnAddBuilding_released():
	if labAddBuilding.text == "Add":
		labAddBuilding.text = "Close"
	else:
		labAddBuilding.text = "Add"
