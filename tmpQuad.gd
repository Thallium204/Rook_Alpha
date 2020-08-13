extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")
onready var bodyWhole = get_node("bodyWhole")

var dict = {
	"U":Vector2( 0,-1),
	"R":Vector2( 1, 0),
	"D":Vector2( 0, 1),
	"L":Vector2(-1, 0)
}

var isFingerHere = true
var inputs = []
var outputs = []
var firstQuadrant = ""
var lastQuadrant = ""

var pullTraffic = false

var extractTimer = 0.3
var timer = 0.0

func _process(delta):
	
	# Draw the textures
	for child in get_children():
		if child.name in inputs:
			child.get_node("quadShape/texQuad").texture = load("res://Assets/Conveyor/conv_quadrants/QuadU_in.png")
		elif child.name in outputs:
			child.get_node("quadShape/texQuad").texture = load("res://Assets/Conveyor/conv_quadrants/QuadU_out.png")
#		else:
#			child.get_node("quadShape/texQuad").texture = load("res://Assets/Conveyor/conv_quadrants/QuadU_none.png")
	
	# Handle extraction
	if timer >= extractTimer and pullTraffic == false:
		for input in inputs:
			var vectorDir = dict[input[-1]]
			var shapeArray = get_parent().shapeData[0][0]
			var inputNode = ctrlFactoryFloor.pointerArray[shapeArray[0]+vectorDir[1]][shapeArray[1]+vectorDir[0]]
			if inputNode != null:
				if inputNode.structureType != "conveyor":
					inputNode.pullResource(self.get_parent())
		timer = 0
	else:
		timer += delta

func addInput(input):
	if not(input in inputs+outputs):
		inputs.append(input)

func addOutput(output):
	if not(output in inputs+outputs):
		outputs.append(output)

func begin():
	isFingerHere = true
	firstQuadrant = lastQuadrant
	if firstQuadrant != "":
		addInput(firstQuadrant)

func end():
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

func exited(_quadrant):
	pass

func _on_bodyWhole_area_shape_entered(area_id, area, area_shape, self_shape):
	if area != null:
		if "Outer" in area.name:
			pullTraffic = true


func _on_bodyWhole_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		if "Outer" in area.name:
			pullTraffic = false
