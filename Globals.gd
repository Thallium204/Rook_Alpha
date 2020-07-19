extends Node2D

onready var labAddBuilding = get_node("TopBarNode/btnAddBuilding/labAddBuilding")

func _on_btnAddBuilding_released():
	if labAddBuilding.text == "Add":
		get_node("TopBarNode").move(Vector2(0,384))
	else:
		get_node("TopBarNode").move(Vector2(0,0))


