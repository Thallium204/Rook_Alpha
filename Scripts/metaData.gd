extends Node2D

func _ready():
	
	# Init processorBank
	for processor in processorBank.values():
		for process in processor["processesData"].values():
			configureProcess(process)
	
	# Init holderBank
	for holder in holderBank.values():
		for buffer in holder["internalStorage"]:
			configureInternalBuffer(buffer)

func configureProcess(process):
	for buffer in process["inputBuffers"]:
		configureInputBuffer(buffer)
	for buffer in process["outputBuffers"]:
		configureOutputBuffer(buffer)
	return process

func configureInputBuffer(buffer):
	buffer["current"] = 0
	buffer["potential"] = 0
	buffer["max"] = ceil(buffer["cost"])
	buffer["type"] = resourceBank[buffer["name"]]["type"]
	return buffer

func configureOutputBuffer(buffer):
	buffer["current"] = 0
	buffer["max"] = ceil(buffer["yield"])
	buffer["type"] = resourceBank[buffer["name"]]["type"]
	return buffer

func configureInternalBuffer(buffer):
	buffer["name"] = ""
	buffer["current"] = 0
	buffer["potential"] = 0
	return buffer

var processorBank = {
	
	# PROCESSORS
	"metaTree":{
		
		"nameID":
			"Tree",
		
		"processesData":{
			"log":{
				"inputBuffers":[],
				"processTime":3,
				"outputBuffers":[
					{"name":"log",		"yield":1}
				]
			},
		}, 
		
		"upgradeData":[],
		
		"shapeData":[
			[1]
		
		]},
	"metaQuarry":{
		
		"nameID":
			"Quarry", 
		
		"processesData":{ 	
			"cobble":{
				"inputBuffers":[],
				"processTime":2,	
				"outputBuffers":[
					{"name":"cobble",	"yield":1}
				]
			},
		}, 
		
		"upgradeData":[],
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	"metaRiver":{
		
		"nameID":
			"River",
		
		"processesData":{
			"clay":{
				"inputBuffers":[],
				"processTime":5,
				"outputBuffers":[
					{"name":"clay",		"yield":3}
				]
			},
		}, 
		
		"upgradeData":[],
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	"metaPlant":{
		
		"nameID":
			"Plant",
		
		"processesData":{
			"hemp":{
				"inputBuffers":[],
				"processTime":3,
				"outputBuffers":[
					{"name":"hemp",		"yield":1}
				]
			},
		},
		
		"upgradeData":[],
		
		"shapeData":[
			[1]
		]},
	"metaFurnace":{
		
		"nameID":
			"Furnace",
		
		"processesData":{
			"brick":{
				"inputBuffers":[
					{"name":"clay",		"cost":1},
					{"name":"plank",	"cost":1}
				],
				"processTime":4,
				"outputBuffers":[
					{"name":"brick",	"yield":1}
				]
			},
		},
		
		"upgradeData":[],
		
		"costData":[
			{"name":"cobble",	"cost":8}
		],
		
		"craftTime":
			2,
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	"metaPotteryTable":{
		
		"nameID":
			"PotteryTable",
		
		"processesData":{
			"ceramic":{
				"inputBuffers":[
					{"name":"clay",		"cost":1}
				],
				"processTime":4,
				"outputBuffers":[
					{"name":"ceramic",	"yield":1}
				]
			},
		},
		
		"upgradeData":[],
		
		"costData":[
			{"name":"log",	"cost":4},
			{"name":"cobble",	"cost":4},
			{"name":"gear",	"cost":16}
		],
		
		"craftTime":
			2,
		
		"shapeData":[
			[1,1]
		]},
	"metaWorkbench":{
		
		"nameID":
			"Workbench",
		
		"processesData":{
			"plank":{
				"inputBuffers":[
					{"name":"log",		"cost":1}
				],
				"processTime":3,
				"outputBuffers":[
					{"name":"plank",	"yield":2}
				],
				
			},
			
		},
		"upgradeData":[],
		
		"costData":[
			{"name":"log",	"cost":4},
			{"name":"hemp",	"cost":3}
		],
		
		"lockedProcesses":{
			
			"gear":{
				"inputBuffers":[
					{"name":"plank",	"cost":1}
				],
				"processTime":3,
				"outputBuffers":[
					{"name":"gear",		"yield":2}
				],
				
				"upgCost":[
					{"name":"log",	"cost":0}
				],
				"upgTime":4
			}
			
		},
		
		"craftTime":
			2,
		
		"shapeData":[
			[1]
		]},
	"metaKiln":{
		
		"nameID":
			"Kiln",
		
		"processesData":{
			"ironclump":{
				"inputBuffers":[
					{"name":"ironore",		"cost":1},
					{"name":"coal",			"cost":1},
				],
				"processTime":8,
				"outputBuffers":[
					{"name":"ironclump",	"yield":1}
				]
			},
			"brick":{
				"inputBuffers":[
					{"name":"clay",			"cost":1}
				],
				"processTime":4,
				"outputBuffers":[
					{"name":"brick",		"yield":1}
				]
			}
		}, 
		
		"upgradeData":[],
		
		"costData":[
			{"name":"clay",	"cost":12},
			{"name":"cobble",	"cost":16},
			{"name":"hemp",	"cost":4},
			{"name":"ceramic",	"cost":16}
		],
		
		"craftTime":
			2,
		
		"shapeData":[
			[1]
		]},
	"metaSmeltery":{
		
		"nameID":
			"Smeltery",
		
		"processesData":{
			"ironingot":{
				"inputBuffers":[
					{"name":"ironclump",	"cost":1}
				],
				"processTime":8,
				"outputBuffers":[
					{"name":"ironingot",	"yield":1}
				]
			},
		}, 
		
		"upgradeData":[],
		
		"costData":[
			{"name":"brick",	"cost":32},
			{"name":"clay",	"cost":32},
			{"name":"cobble",	"cost":32}
		],
		
		"craftTime":
			2,
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	"metaMineshaft":{
		
		"nameID":
			"Mineshaft",
		
		"processesData":{
			"ironore":{
				"inputBuffers":[],
				"processTime":8,
				"outputBuffers":[
					{"name":"ironore",	"yield":1},
					{"name":"coal",		"yield":1},
				]
			},
		}, 
		
		"upgradeData":[],
		
		"costData":[],
		
		"craftTime":
			5,
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	
}

var holderBank = {
	# HOLDERS
	"metaHole":{
		
		"nameID":
			"Hole",
		
		"internalStorage":[
			{"max":16,	"type":"solid"}
		],
		
		"upgradeData":[],
		
		"shapeData":[
			[1]
		]},
	"metaHole2":{
		
		"nameID":
			"Hole2",
		
		"internalStorage":[
			{"max":64,	"type":"solid"}
		],
		
		"upgradeData":[],
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	
}

var enhancerBank = {
	
	# ENHANCERS
	"metaHeater":{
		
		"nameID":
			"Heater",
		
		"upgradeData":[]
		
	}
	
}

var conveyorBank = {
	
	"metaDense":{
		
		"nameID":
			"Dense",
		
		"conveyorSpeed":
			1,
		
		"upgradeData":[]
		
	},
	"metaNormal":{
		
		"nameID":
			"Normal",
		
		"conveyorSpeed":
			2,
		
		"upgradeData":[]
		
	},
	"metaVacuum":{
		
		"nameID":
			"Vacuum",
		
		"conveyorSpeed":
			3,
		
		"upgradeData":[]
		
	},
	"metaImpulse":{
		
		"nameID":
			"Impulse",
		
		"conveyorSpeed":
			4,
		
		"upgradeData":[]
		
	},
	"metaWarp":{
		
		"nameID":
			"Warp",
		
		"conveyorSpeed":
			6,
		
		"upgradeData":[]
		
	}
}


var pipeBank = {
	
	"metaNormalPipe":{
		
		"nameID":
			"NormalPipe",
		
		"pipeSpeed":
			2
	}
}


var cableBank = {
	
	"metaStandard":{
		
		"nameID":
			"Standard"
	}
}

var resourceBank = {
	
	"log":		{"type":"solid"},
	"cobble":	{"type":"solid"},
	"clay":		{"type":"solid"},
	"plank":	{"type":"solid"},
	"brick":	{"type":"solid"},
	"hemp":		{"type":"solid"},
	"ceramic":	{"type":"solid"},
	"gear":		{"type":"solid"},
	"coal":		{"type":"solid"},
	"ironore":	{"type":"solid"},
	"ironclump":{"type":"solid"},
	"ironingot":{"type":"solid"},
	
	"water":	{"type":"fluid"},
	
	"power":	{"type":"power"}
	
	}


var upgradesBank = {
	
	"Workbench":
		{
			"plank":
				{
					1:{
						"column":1,
						"row":1,
						"prerequisites":[],
						"reference":["plank", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"plank",	"cost":0},
							{"name":"gear",	"cost":0},
							{"name":"cobble",	"cost":0}
						]
					},
					2:{
						"column":1,
						"row":2,
						"prerequisites":[],
						"reference":["plank", "outputBuffers", 0, "yield"],
						"info":0.5,
						"cost":[
							{"name":"plank",	"cost":0}
						]
					},
					3:{
						"column":2,
						"row":1,
						"prerequisites":[1],
						"reference":["plank", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"plank",	"cost":0}
						]
					},
					4:{
						"column":2,
						"row":2,
						"prerequisites":[1,2],
						"reference":["plank", "inputBuffers", 0, "cost"],
						"info":-0.5,
						"cost":[
							{"name":"plank",	"cost":0}
						]
					},
					5:{
						"column":3,
						"row":1,
						"prerequisites":[3],
						"reference":["plank", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"plank",	"cost":0}
						]
					},
					6:{
						"column":3,
						"row":2,
						"prerequisites":[4],
						"reference":["plank", "outputBuffers", 0, "yield"],
						"info":1,
						"cost":[
							{"name":"plank",	"cost":0}
						]
					},
					7:{
						"column":4,
						"row":1,
						"prerequisites":[5,6],
						"reference":["plank", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"plank",	"cost":0}
						]
					}
				},

				"gear":
				{
					1:{
						"column":1,
						"row":1,
						"prerequisites":[],
						"reference":["gear", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"gear",	"cost":1}
						]
					},
					2:{
						"column":2,
						"row":1,
						"prerequisites":[1],
						"reference":["gear", "outputBuffers", 0, "yield"],
						"info":1,
						"cost":[
							{"name":"gear",	"cost":2}
						]
					},
					3:{
						"column":2,
						"row":2,
						"prerequisites":[],
						"reference":["gear", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"gear",	"cost":3}
						]
					},
					4:{
						"column":2,
						"row":3,
						"prerequisites":[1],
						"reference":["gear", "outputBuffers", 0, "yield"],
						"info":1,
						"cost":[
							{"name":"gear",	"cost":4}
						]
					},
					5:{
						"column":3,
						"row":1,
						"prerequisites":[2,3],
						"reference":["gear", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"gear",	"cost":5}
						]
					},
					6:{
						"column":3,
						"row":2,
						"prerequisites":[4],
						"reference":["gear", "outputBuffers", 0, "yield"],
						"info":1,
						"cost":[
							{"name":"gear",	"cost":6}
						]
					},
					7:{
						"column":4,
						"row":1,
						"prerequisites":[5,6],
						"reference":["gear", "processTime"],
						"info":-0.5,
						"cost":[
							{"name":"gear",	"cost":7}
						]
					}
				}
		},

}


