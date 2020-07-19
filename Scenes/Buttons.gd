extends Node2D

# Enter the name of the resource i.e. for btnPlanks enter "Planks"
var resourceBank = [
	[ "Cobble",		30,		[], 				1	],
	[ "Furnace",	80,		[ ["Cobble",8] ], 	1	],
	[ "Log",		50,		[], 				1	],
	[ "Planks",		40,		[ ["Log",1] ],		4	],
	[ "Table",		160,	[ ["Planks",4] ],	1	],
	[ "Chest",		360,	[ ["Planks",8] ],	1	]
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	for res in resourceBank:
		get_node("btn"+res[0]).resName = res[0]
		get_node("btn"+res[0]).resTime = res[1]
		get_node("btn"+res[0]).resCost = res[2]
		get_node("btn"+res[0]).resGain = res[3]
		get_node("btn"+res[0]).initialiseNodeRefs()
	pass # Replace with function body.
