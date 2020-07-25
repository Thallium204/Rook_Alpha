extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var hasMoved = false
var checkForMovement = false

func _input(event):
	if checkForMovement == true:
		if event is InputEventMouseMotion:
			hasMoved = true

# WHEN ADD STORAGE IS PRESSED
func _on_btnAddBuilding_released():
	checkForMovement = false
	if hasMoved == false: # If this was a click not a drag
		var nameID = str(self.name).right(6) # Get button name then isolate nameID i.e. "btnAddQuary" -> "Quary"
		Globals.initialseBuildingData(nameID) # Initialise building data based on nameID of button
	hasMoved = false


func _on_btnAddBuilding_pressed():
	checkForMovement = true

