extends Node2D

func _ready():
	for processor in processorBank.values():
		for process in processor["processesData"].values():
			for buffer in process["inputBuffers"]:
				buffer["bufferCurrent"] = 0
				buffer["bufferPotential"] = 0
	for holder in holderBank.values():
		for buffer in holder["internalStorage"]:
			buffer["bufferCurrent"] = 0
			buffer["bufferPotential"] = 0

var processorBank = {
	
	# PROCESSORS
	"metaTree":{
		
		"nameID":
			"Tree",
		
		"processesData":{
			"Log":{
				"inputBuffers":[],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Log",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
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
			"Cobble":{
				"inputBuffers":[],
				"processTime":2,	
				"outputBuffers":[
					{"resourceName":"Cobble",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
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
			"Clay":{
				"inputBuffers":[],
				"processTime":5,
				"outputBuffers":[
					{"resourceName":"Clay",		"bufferCurrent":0,	"bufferMax":3,	"resourceType":"Solid"}
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
			"Hemp":{
				"inputBuffers":[],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Hemp",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
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
			"Brick":{
				"inputBuffers":[
					{"resourceName":"Clay",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
					{"resourceName":"Plank",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":4,
				"outputBuffers":[
					{"resourceName":"Brick",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			},
		},
		
		"upgradeData":[],
		
		"costData":[
			{"resourceName":"Cobble",	"amountRequired":8}
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
			"Ceramic":{
				"inputBuffers":[
					{"resourceName":"Clay",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":4,
				"outputBuffers":[
					{"resourceName":"Ceramic",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			},
		},
		
		"upgradeData":[],
		
		"costData":[
			{"resourceName":"Log",	"amountRequired":4},
			{"resourceName":"Cobble",	"amountRequired":4},
			{"resourceName":"Gear",	"amountRequired":16}
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
			"Plank":{
				"inputBuffers":[
					{"resourceName":"Log",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Plank",	"bufferCurrent":0,	"bufferMax":2,	"resourceType":"Solid"}
				],
				
			},
			
		},
		"upgradeData":[],
		
		"costData":[
			{"resourceName":"Log",	"amountRequired":4},
			{"resourceName":"Hemp",	"amountRequired":3}
		],
		
		"lockedProcesses":{
			
			"Gear":{
				"inputBuffers":[
					{"resourceName":"Plank",	"bufferPotential":0,	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Gear",	"bufferPotential":0,    "bufferCurrent":0,	"bufferMax":2,	"resourceType":"Solid"}
				],
				
				"upgCost":[
					{"resourceName":"Log",	"amountRequired":0}
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
			"IronClump":{
				"inputBuffers":[
					{"resourceName":"Ironore",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
					{"resourceName":"Coal",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
				],
				"processTime":8,
				"outputBuffers":[
					{"resourceName":"Ironclump","bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			},
			"Brick":{
				"inputBuffers":[
					{"resourceName":"Clay",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":4,
				"outputBuffers":[
					{"resourceName":"Brick",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			}
		}, 
		
		"upgradeData":[],
		
		"costData":[
			{"resourceName":"Clay",	"amountRequired":12},
			{"resourceName":"Cobble",	"amountRequired":16},
			{"resourceName":"Hemp",	"amountRequired":4},
			{"resourceName":"Ceramic",	"amountRequired":16}
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
			"Ironingot":{
				"inputBuffers":[
					{"resourceName":"Ironclump","bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":8,
				"outputBuffers":[
					{"resourceName":"Ironingot","bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			},
		}, 
		
		"upgradeData":[],
		
		"costData":[
			{"resourceName":"Brick",	"amountRequired":32},
			{"resourceName":"Clay",	"amountRequired":32},
			{"resourceName":"Cobble",	"amountRequired":32}
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
			"IronOre":{
				"inputBuffers":[],
				"processTime":8,
				"outputBuffers":[
					{"resourceName":"Ironore","bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
					{"resourceName":"Coal","bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
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
			{"resourceName":"",			"bufferCurrent":0,	"bufferMax":16,	"resourceType":"Solid"}
		],
		
		"upgradeData":[],
		
		"shapeData":[
			[1]
		]},
	"metaHole2":{
		
		"nameID":
			"Hole2",
		
		"internalStorage":[
			{"resourceName":"",			"bufferCurrent":0,	"bufferMax":64,	"resourceType":"Solid"}
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
	
	"metaSlow":{
		
		"nameID":
			"Slow",
		
		"conveyorSpeed":
			0.2,
		
		"upgradeData":[]
		
		},
	"metaStandard":{
		
		"nameID":
			"Standard",
		
		"conveyorSpeed":
			0.5,
		
		"upgradeData":[]
		
		},
	"metaFast":{
		
		"nameID":
			"Fast",
		
		"conveyorSpeed":
			1,
		
		"upgradeData":[]
		
		},
	"metaRapid":{
		
		"nameID":
			"Rapid",
		
		"conveyorSpeed":
			2,
		
		"upgradeData":[]
		
		}
	
}


var pipeBank = {
	
	"metaStandard":{
		
		"nameID":
			"Standard"}
}


var cableBank = {
	
	"metaStandard":{
		
		"nameID":
			"Standard"}
}

var resourceBank = [
	
	["Log",			"Solid"],
	
	["Cobble",		"Solid"],
	
	["Clay",		"Solid"],
	
	["Plank",		"Solid"],
	
	["Brick",		"Solid"],
	
	["Hemp",		"Solid"],
	
	["Ceramic",		"Solid"],
	
	["Gear",		"Solid"],
	
	["Ironore",		"Solid"],
	
	["Ironclump",	"Solid"],
	
	["Coal",		"Solid"],
	
	["Water",		"Fluid"],
	
	["Power",		"Power"],
	
	["Clay",		"Solid"],
	
	["Ironore",		"Solid"],
	
	["Ironclump",	"Solid"],
	
	["Ironingot",	"Solid"]
	
	]


var upgradesBank = {
	
	"Workbench":
		{
			"Plank":
				{
					1:{
						"column":1,
						"row":1,
						"prerequisites":[],
						"reference":["Plank", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0},
							{"resourceName":"Gear",	"amountRequired":0},
							{"resourceName":"Cobble",	"amountRequired":0}
						]
					},
					2:{
						"column":1,
						"row":2,
						"prerequisites":[],
						"reference":["Plank", "outputBuffers", 0, "bufferMax"],
						"info":1,
						"tooltip":"increases yield by 1",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0}
						]
					},
					3:{
						"column":2,
						"row":1,
						"prerequisites":[1],
						"reference":["Plank", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0}
						]
					},
					4:{
						"column":2,
						"row":2,
						"prerequisites":[1,2],
						"reference":["Plank", "outputBuffers", 0, "bufferMax"],
						"info":1,
						"tooltip":"increases yield by 1",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0}
						]
					},
					5:{
						"column":3,
						"row":1,
						"prerequisites":[3],
						"reference":["Plank", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0}
						]
					},
					6:{
						"column":3,
						"row":2,
						"prerequisites":[4],
						"reference":["Plank", "outputBuffers", 0, "bufferMax"],
						"info":1,
						"tooltip":"increases yield by 1",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0}
						]
					},
					7:{
						"column":4,
						"row":1,
						"prerequisites":[5,6],
						"reference":["Plank", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Plank",	"amountRequired":0}
						]
					}
				},

				"Gear":
				{
					1:{
						"column":1,
						"row":1,
						"prerequisites":[],
						"reference":["Gear", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":1}
						]
					},
					2:{
						"column":2,
						"row":1,
						"prerequisites":[1],
						"reference":["Gear", "outputBuffers", 0, "bufferMax"],
						"info":1,
						"tooltip":"increases yield by 1",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":2}
						]
					},
					3:{
						"column":2,
						"row":2,
						"prerequisites":[],
						"reference":["Gear", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":3}
						]
					},
					4:{
						"column":2,
						"row":3,
						"prerequisites":[1],
						"reference":["Gear", "outputBuffers", 0, "bufferMax"],
						"info":1,
						"tooltip":"increases yield by 1",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":4}
						]
					},
					5:{
						"column":3,
						"row":1,
						"prerequisites":[2,3],
						"reference":["Gear", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":5}
						]
					},
					6:{
						"column":3,
						"row":2,
						"prerequisites":[4],
						"reference":["Gear", "outputBuffers", 0, "bufferMax"],
						"info":1,
						"tooltip":"increases yield by 1",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":6}
						]
					},
					7:{
						"column":4,
						"row":1,
						"prerequisites":[5,6],
						"reference":["Gear", "processTime"],
						"info":-0.5,
						"tooltip":"decreases process time by 0.5s",
						"cost":[
							{"resourceName":"Gear",	"amountRequired":7}
						]
					}
				}
		},

}


