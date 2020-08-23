extends "res://Scripts/classFactoryEntity.gd"

var connectorType = "" 			# Type of structure: conveyor|pipe|cable
var _levelData = [] 			# List of all upgrade modifiers

# BOOLEANS

func _ready():
	imageDirectory += "/Connector"
	entityType = "Connector"

func _process(_delta):
	
	pass

func configure_Connector(connectorData):
	
	entityShape = [[1]]
	
	configure_Entity(connectorData)

func onPressed_Connector(tile): # Pressed Processes for all structures
	
	# Handle Entity
	onPressed_Entity(tile)

func onReleased_Connector(tile): # Released Processes for all structures
	
	# Handle Entity
	onReleased_Entity(tile)







