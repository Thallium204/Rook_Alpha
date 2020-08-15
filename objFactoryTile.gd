extends TouchScreenButton

onready var Globals = null
onready var ctrlFactoryFloor = null

var repeatEnteredList = [] 	# List of area nodes we constantly call the "entered" function for
var tileRC = []			# [row,colummn] | The indexes for the pointerArray
var fatherNode = null

# NOTE: You 'enter' the new area BEFORE 'exiting' the old one (if there is no gap between the areas)

func reparent(newParent):
	get_parent().remove_child(self) # Remove ourself from our current parent
	newParent.add_child(newParent) # Add ourself as child to new parent

func updatePosition():
	position = ctrlFactoryFloor.tileSize*Vector2(tileRC[1],tileRC[0])

func _ready():
	Globals = get_tree().get_root().get_node("Game/Globals")
	ctrlFactoryFloor = Globals.get_node("FactoryNode/ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")

func _process(_delta):
	# Treat the trackArea's like they are entering every frame
	for area in repeatEnteredList:
		_on_areaTile_area_entered(area)

# Area2D Signals

# When a node's Area enters our Area
func _on_areaTile_area_entered(area):
	pass # Replace with function body.

# When a node's Area exits our Area
func _on_areaTile_area_exited(area):
	pass # Replace with function body.

# When the mouse enters our Area
func _on_areaTile_mouse_entered():
	#print("\nEntered: ",tileRC)
	if Globals.drawConveyorMode == "moving":
		var newConveyor = ctrlFactoryFloor.addConnector()
		newConveyor.rect_position = position
		ctrlFactoryFloor.add_child(newConveyor)

# When the mouse exits our Area
func _on_areaTile_mouse_exited():
	#print("Exited: ",tileRC)
	pass


# TouchScreenButton Signals

# When the mouse presses our Button
func _on_objFactoryTile_pressed():
	
	if fatherNode == null:
		return
	
	fatherNode.onPressed(tileRC)

# When the mouse releases our Button
func _on_objFactoryTile_released():
	
	if fatherNode == null:
		return
	
	fatherNode.onReleased(tileRC)












