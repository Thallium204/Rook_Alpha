extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")

var isFingerHere = true
var inputs = []
var outputs = []
var firstQuadrant = ""
var lastQuadrant = ""

func _process(_delta):
	
	# Draw the textures
	for child in get_children():
		if child.name in inputs:
			child.get_node("quadShape/texQuad").texture = load("res://Assets/Conveyor/conv_quadrants/QuadU_in.png")
		elif child.name in outputs:
			child.get_node("quadShape/texQuad").texture = load("res://Assets/Conveyor/conv_quadrants/QuadU_out.png")
#		else:
#			child.get_node("quadShape/texQuad").texture = load("res://Assets/Conveyor/conv_quadrants/QuadU_none.png")
	
	# Handle extraction and insertion
	

func addInput(input):
	if not(input in inputs+outputs):
		inputs.append(input)

func addOutput(output):
	if not(output in inputs+outputs):
		outputs.append(output)

func begin():
	print(self," BEGIN")
	isFingerHere = true
	firstQuadrant = lastQuadrant
	if firstQuadrant != "":
		addInput(firstQuadrant)

func end():
	print(self," END")
	isFingerHere = false
	addOutput(lastQuadrant)
	# Add new Conveyor
	ctrlFactoryFloor.addConveyor(get_parent().shapeData[0][0].duplicate(),lastQuadrant)
	
	# Get the quadrant we're coming into
	var oppositeQuadrant = "bodyQuad?"
	if lastQuadrant == "bodyQuadU":
		oppositeQuadrant = "bodyQuadD"
	elif lastQuadrant == "bodyQuadR":
		oppositeQuadrant = "bodyQuadL"
	elif lastQuadrant == "bodyQuadD":
		oppositeQuadrant = "bodyQuadU"
	elif lastQuadrant == "bodyQuadL":
		oppositeQuadrant = "bodyQuadR"
	if inputs.size() == 0:
		inputs.append(oppositeQuadrant)

func entered(quadrant):
	
	if isFingerHere == true:
		lastQuadrant = quadrant
		print(self," Entering: ",lastQuadrant)

func exited(_quadrant):
	
	print(self," Leaving: ",lastQuadrant)
	
	
