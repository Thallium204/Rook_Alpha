extends Node2D

onready var sprResource = get_node("sprResource")

var tileList = []
var inputBuffer = null
var speed = 0.5
var resourceName = ""

func configure(resName,tilePath,buffer):
	resourceName = resName
	tileList = tilePath.duplicate()
	$sprResource.texture = load("res://Assets/Resources/img_"+resourceName.to_lower()+".png")
	position = tileList[0].position
	inputBuffer = buffer
	tileList.remove(0)

func _process(delta):
	
	if tileList.empty(): # If we have arrived
		inputBuffer["bufferCurrent"] += 1
		queue_free()
	else:
		var direction = (tileList[0].position - position).normalized()
		if (position - tileList[0].position).length() < speed:
			position = tileList[0].position
			if tileList[0].fatherNode != null:
				tileList.remove(0)
			else:
				queue_free()
		else:
			position += direction*speed*delta*100
