extends "res://classFactoryEntity.gd"

var connectorName = "" 		# Name of the structure i.e. "Standard"
var connectorType = "" 		# Type of structure: conveyor|pipe|cable
var _levelData = [] 		# List of all upgrade modifiers

# BOOLEANS

func _ready():
	imageDirectory += "/Connector"
	entityType = "Connector"

func _process(_delta):
	
	pass

func onPressed_Connector(tile): # Pressed Processes for all structures
	
	if Globals.drawConveyorMode == "ready":
		# Begin the conveyor drawing
		Globals.drawConveyorMode = "moving"
	
	# Handle Entity
	onPressed_Entity(tile)

func onReleased_Connector(tile): # Released Processes for all structures
	
	# Handle Entity
	onReleased_Entity(tile)
	
	# Stop if we have moved our mouse since pressing
	if hasDragged == true:
		return
	
	# If we're in delete mode
	if Globals.deleteStructureMode == true:
		deleteSelf()
		#Globals.deleteStructureMode = false
	
	if Globals.moveStructureMode == "off":
		if Globals.displayInfoMode == true:
			if texInfoBar.infoNode != self:
				texInfoBar.infoNode = self
			texInfoBar.updateInfo()
	
	if Globals.drawConveyorMode == "moving":
		# End the conveyor drawing
		Globals.drawConveyorMode = "ready"







