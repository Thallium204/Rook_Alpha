extends Node2D

# Enter the name of the resource i.e. for btnPlanks enter "Planks"
var resourceBank = [

	[ "Log",		50,		[], 				1000	]]


# Called when the node enters the scene tree for the first time.
func _ready():
	for res in resourceBank:
		get_node("btn"+res[0]).resName = res[0]
		get_node("btn"+res[0]).resTime = res[1]
		get_node("btn"+res[0]).resCost = res[2]
		get_node("btn"+res[0]).resGain = res[3]
		get_node("btn"+res[0]).initialiseNodeRefs()
	pass # Replace with function body.
