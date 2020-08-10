extends Area2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var quadrant = ""	# QuadU|QuadR|QuadD|QuadL|QuadC|Whole
var state = "none"	# input|output|none

func _ready():
	connect("mouse_entered",self,"_on_bodyQuad_mouse_entered")
	connect("mouse_exited",self,"_on_bodyQuad_mouse_exited")
	#quadrant = name.substr(4,8)
	quadrant = name

func _on_bodyQuad_mouse_entered():
	if Globals.drawConveyorMode == "moving":
		#modulate = Color(0,0,1)
		if quadrant != "bodyQuadC":
			get_parent().entered(quadrant)

func _on_bodyQuad_mouse_exited():
	if Globals.drawConveyorMode == "moving":
		#modulate = Color(1,1,1)
		if quadrant != "bodyQuadC":
			get_parent().exited(quadrant)
