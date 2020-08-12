extends Node2D

onready var bodyOuter = get_node("bodyOuter")
onready var bodyInner = get_node("bodyInner")
onready var sprResource = get_node("sprResource")


var toPosition = self.position
var speed = 0.5
var waiting = null
var stop = false
var resourceName = ""

func _process(_delta):
	
	if stop == false and waiting == null:
		position += (toPosition-position).normalized()*speed
		$bodyDetect.position = (toPosition-position).normalized()*9
	elif waiting != null:
		_on_bodyDetect_area_shape_entered(null, waiting, null, null)


func _on_bodyDetect_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if "Outer" in area.name and area.get_parent() != self:
		stop = true
	elif area.get_parent() != self and not("Quad" in area.name) and not("Whole" in area.name) and not("Resource" in area.name):
		var structureNode = area.get_parent().get_parent().get_parent()
		#print(area.name)
		if structureNode.structureType != "conveyor":
			if structureNode.inputResource(resourceName) == false:
				waiting = area
			else:
				queue_free()


func _on_bodyDetect_area_shape_exited(_area_id, area, _area_shape, _self_shape):
	if "Outer" in area.name and area.get_parent() != self:
		stop = false
