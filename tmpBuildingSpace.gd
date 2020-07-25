extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var UIPermission = true
var checkForMovement = true
var hasMoved = false

func _process(_delta):
	
	# Prevent clicking when menu is open
	if Globals.isMenuOpen == false:
		UIPermission = true
	else:
		UIPermission = false

func _input(event):
	if checkForMovement == true:
		if event is InputEventMouseMotion:
			hasMoved = true

func _on_btnProcess_released():
	
	if Globals.moveBuildingsMode == true and UIPermission == true:
		if Globals.movePair[0] != null: # If we're the second selection (TO)
			Globals.movePair[1] = self
			Globals.initialiseMoveData()

func _on_btnProcess_pressed():
	checkForMovement = true
