extends Node2D

onready var sprResource = get_node("sprResource")
onready var timeSpeed = get_node("timeSpeed")

var tileList = []
var inputBuffer = null
var speed
var resourceName = ""

func configure(resName,tilePath,buffer):
	resourceName = resName
	tileList = tilePath.duplicate()
	$timeSpeed.wait_time =  1/float(tileList[1].fatherNode.conveyorSpeed)
	$sprResource.texture = load("res://Assets/Resources/img_"+resourceName+".png")
	position = tileList[0].position
	inputBuffer = buffer
	tileList.remove(0)

func _process(_delta):
	
	var prcProgress = 1-($timeSpeed.time_left/$timeSpeed.wait_time)
	position = tileList[0].position + prcProgress*(tileList[1].position-tileList[0].position) + Vector2(16,16)

func updateSpeed():
	$timeSpeed.stop()
	$timeSpeed.wait_time = 1/float(tileList[0].fatherNode.conveyorSpeed)
	$timeSpeed.start()

func _on_timeSpeed_timeout():
	
	if tileList.size() == 2: # If we've reached our destination
		inputBuffer["current"] += 1 # input the resource
		queue_free() # Kill self
	else: # If we're not there yet
		tileList.remove(0)
		if tileList[0].fatherNode != null: # If we've reached the next tile
			updateSpeed()
		else: # If we've been derailed
			inputBuffer["potential"] -= 1 # Release the potential
			queue_free() # Kill self
