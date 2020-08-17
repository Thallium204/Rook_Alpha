extends Node2D

onready var areaNodes = [get_node("bodyOuter"),get_node("bodyDetect"),get_node("bodyInner")]
onready var sprResource = get_node("sprResource")


var toPosition = Vector2.ZERO
var speed = 0.5
var waiting = null
var stop = false
var resourceName = ""
var resourceType = "Solid"

func _process(_delta):
	
	if waiting == null:
		
		if stop == false:
		
			var direction = (toPosition - position).normalized()
			if (position - toPosition).length() < speed:
				position = toPosition
			else:
				position += direction*speed
			$bodyDetect.position = direction*9
		
	else:
		
		if waiting.entityType == "Connector":
			waiting.pointResource(self)
		elif waiting.entityType == "Structure":
			waiting.inputResource(self)

# DETECT SHAPE
func _on_bodyDetect_area_entered(area):
	
	print(area.name)
	if "Outer" in area.name and area.get_parent() != self:
		stop = true


func _on_bodyDetect_area_exited(area):
	
	if "Outer" in area.name and area.get_parent() != self:
		stop = false
