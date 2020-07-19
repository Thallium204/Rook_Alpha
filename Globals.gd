extends Node2D

onready var labAddBuilding = get_node("TopBarNode/btnAddBuilding/labAddBuilding")

# TAPPING A TOPBAR MENU OPTION (RELEASE)
func _on_btnAddBuilding_released():
	if labAddBuilding.text == "Add": # If the menu is closed
		get_node("TopBarNode").move(Vector2(0,384)) # Open the menu
	else:
		get_node("TopBarNode").move(Vector2(0,0)) # Close the menu


# TAPPING A BUILDING (RELEASE)
func _on_btnProcess_released():
	if labAddBuilding.text == "Close": # If we tap a building when a menu is open
		get_node("TopBarNode").move(Vector2(0,0)) # Close the menu
		labAddBuilding.text = "Add"
