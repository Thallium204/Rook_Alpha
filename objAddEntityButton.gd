extends TextureRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var TopBarNode = get_parent().get_parent()

var hasMoved = false
var checkForMovement = false

var entityType = ""
var entityName = ""
var subType = ""

func _input(event):
	if checkForMovement == true:
		if event is InputEventMouseMotion:
			hasMoved = true

# WHEN ADD STORAGE IS PRESSED
func _on_btnAdd_released():
	checkForMovement = false
	if hasMoved == false and Globals.moveStructureMode == "off": # If this was a click not a drag
		if entityType == "Structure":
			TopBarNode.call("_on_btn"+subType+"Menu_pressed")
			Globals.initialseStructureData(entityName,subType) # Initialise building data based on nameID of button
		elif entityType == "Connector":
			TopBarNode.call("_on_btn"+entityType+"Menu_pressed")
			Globals.drawConnector = {"nameID":entityName,"connectorType":subType}
	hasMoved = false

func _on_btnAdd_pressed():
	checkForMovement = true
