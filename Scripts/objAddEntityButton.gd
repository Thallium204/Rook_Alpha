extends TextureRect

onready var Menus = get_tree().get_root().get_node("Game/Menus")
onready var ctrlFactoryFloor = Menus.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
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

func _process(_delta):
	if Inventory.entityInv[entityName] > 0: # If we have any entities
		$labAmount.visible = true
		modulate = Color(1,1,1)
		$labAmount.text = str(Inventory.entityInv[entityName])
	else:
		$labAmount.visible = false
		modulate = Color(0.5,0.5,0.5)

# WHEN ADD STORAGE IS PRESSED
func _on_btnAdd_released():
	
	if Inventory.entityInv[entityName] == 0:
		return
	
	if Globals.moveStructureMode != "moving":
		if entityType == "Structure":
			TopBarNode.call("_on_btn"+subType+"Menu_pressed")
			var structureData = Globals.initialseStructureData(entityName,subType)
			ctrlFactoryFloor.addStructure(structureData,subType)
		elif entityType == "Connector":
			TopBarNode.call("_on_btn"+entityType+"Menu_pressed")
			if Globals.drawConnector["nameID"] != entityName:
				Globals.drawConnector = {"nameID":entityName,"connectorType":subType}
			else:
				Globals.drawConnector = {"nameID":"","connectorType":""}
	hasMoved = false

func _on_btnAdd_pressed():
	pass
