extends Node2D

onready var bodyOuter = get_node("bodyOuter")
onready var bodyInner = get_node("bodyInner")
onready var sprResource = get_node("sprResource")


var toPosition = Vector2.ZERO
var speed = 0.5
var waiting = null
var stop = false
var resourceName = ""
var conveyorList = [null]

func addConveyor(node):
	if not(node in conveyorList):
		conveyorList.append(node)

func removeConveyor(node):
	print(node.name)
	if node in conveyorList:
		conveyorList.erase(node)
	if null in conveyorList:
		conveyorList.erase(null)

func _process(_delta):
	
	if stop == false and waiting == null and toPosition != Vector2.ZERO:
		position += (toPosition-position).normalized()*speed
		$bodyDetect.position = (toPosition-position).normalized()*9
	elif waiting != null:
		if is_instance_valid(waiting):
			_on_bodyDetect_area_shape_entered(null, waiting, null, null)
		else:
			waiting = false
	
	if conveyorList.empty():
		queue_free()

# DETECT SHAPE
func _on_bodyDetect_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	
	if "Outer" in area.name and area.get_parent() != self:
		stop = true
	elif ("Inner" in area.name or "Detect" in area.name) and area.get_parent() != self:
		pass
	elif area.get_parent() != self and not("Quad" in area.name) and not("Whole" in area.name) and not("Resource" in area.name):
		if area.is_queued_for_deletion():
				return
		var structureNode = area.get_parent().get_parent().get_parent()
		
		if structureNode.structureType != "Conveyor":
			if structureNode.inputResource(resourceName) == false:
				waiting = area
			else:
				queue_free()

func _on_bodyDetect_area_shape_exited(_area_id, area, _area_shape, _self_shape):
	if area != null:
		if "Outer" in area.name and area.get_parent() != self:
			stop = false
