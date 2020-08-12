extends Area2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryNode = Globals.get_node("FactoryNode")
onready var ctrlFactoryFloor = FactoryNode.get_node("ctnFactoryViewport/vptFactoryScene/ctrlFactoryFloor")

var quadrant = ""	# QuadU|QuadR|QuadD|QuadL|QuadC|Whole
var state = "none"	# input|output|none
var robin = 0
var speed = 0

var dict = {
	"U":Vector2( 0,-1),
	"R":Vector2( 1, 0),
	"D":Vector2( 0, 1),
	"L":Vector2(-1, 0)
}

func _ready():
	connect("mouse_entered",self,"_on_bodyQuad_mouse_entered")
	connect("mouse_exited",self,"_on_bodyQuad_mouse_exited")
	connect("area_shape_entered",self,"shapeEntered")
	#quadrant = name.substr(4,8)
	quadrant = name

func shapeEntered( _area_id , area , _area_shape , _self_shape ):
	
	var objConveyor = get_parent().get_parent()
	
	if not("Quad" in area.name) and not("Whole" in area.name): # Ignore ourself
		#print(area_id," ",area," ",area_shape," ",self_shape)
		if "Inner" in area.name:
			var nodeAbove = area.get_parent()
			#print(self.name," is touching ",nodeAbove.name)
			if self.name == "bodyQuadC": # If we're in the center
				if not(get_parent().outputs.empty()):
					var vectorDir = dict[ get_parent().outputs[robin][-1] ]
					nodeAbove.toPosition = objConveyor.rect_position + 32*vectorDir + Vector2(16,16)
					robin += 1
					robin %= get_parent().outputs.size()
				else:
					nodeAbove.toPosition = nodeAbove.position

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
