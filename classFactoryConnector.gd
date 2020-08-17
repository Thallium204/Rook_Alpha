extends "res://classFactoryEntity.gd"

var connectorType = "" 			# Type of structure: conveyor|pipe|cable
var _levelData = [] 			# List of all upgrade modifiers

# BOOLEANS

func _ready():
	imageDirectory += "/Connector"
	entityType = "Connector"
	entityShape = [[1]]

func _process(_delta):
	
	pass

func onPressed_Connector(tile): # Pressed Processes for all structures
	
	# Handle Entity
	onPressed_Entity(tile)

func onReleased_Connector(tile): # Released Processes for all structures
	
	# Handle Entity
	onReleased_Entity(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return







