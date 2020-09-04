extends Node2D

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
				"speedLevel":0,
				"inputLevel":0,
				"outputLevel":0
				
			},
			
		},
		
		"costData":[
			{"resourceName":"Log",	"amountRequired":4},
			{"resourceName":"Hemp",	"amountRequired":3}
		],
		
		"upgradeData":[
			
			{
				"action":"edit",
				"type":"modify",
				"name":"Plank",
				"level":1,
				"class":"speed",
				"reference":["metaWorkbench","processesData", 0, "processTime"],
				"info":0.1,
				"upgCost":[
					{"resourceName":"Log",	"amountRequired":0}
				],
				"upgTime":2
			},
			
			{
				"action":"edit",
				"type":"modify",
				"name":"Plank",
				"level":1,
				"class":"output",
				"reference":["metaWorkbench","processesData", 0, "outputBuffers"], 
				"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":3,	"resourceType":"Solid"},
				"upgCost":[
					{"resourceName":"Log",	"amountRequired":0}
				],
				"upgTime":2
			},
			
			{
				"action":"add",
				"class":"newProc",
				"name":"Gear",
				"ref":["processData"],
				"info":{
					
					"inputBuffers":[
						{"resourceName":"Plank",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
					],
					"processTime":3,
					"outputBuffers":[
							{"resourceName":"Gear",		"bufferCurrent":0,	"bufferMax":2,	"resourceType":"Solid"}
						],
					"speedLevel":0,
					"inputLevel":0,
					"outputLevel":0
					
				},
				"upgCost":[
					{"resourceName":"Log",	"amountRequired":0}
				],
				"upgTime":2
			}
			
		],
		
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
		
		"shapeData":[
			[1]
		]},
	"metaHole2":{
		
		"nameID":
			"Hole2",
		
		"internalStorage":[
			{"resourceName":"",			"bufferCurrent":0,	"bufferMax":64,	"resourceType":"Solid"}
		],
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	
}

var enhancerBank = {
	
	# ENHANCERS
	"metaHeater":{
		
		"nameID":
			"Heater"
		}
	
}

var conveyorBank = {
	
	"metaSlow":{
		
		"nameID":
			"Slow",
		
		"conveyorSpeed":
			0.2
		},
	"metaStandard":{
		
		"nameID":
			"Standard",
		
		"conveyorSpeed":
			0.5
		},
	"metaFast":{
		
		"nameID":
			"Fast",
		
		"conveyorSpeed":
			1
		},
	"metaRapid":{
		
		"nameID":
			"Rapid",
		
		"conveyorSpeed":
			2
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
						"reference":["metaWorkbench","processesData", "Plank", "processTime"],
						"info":2.5,
						"cost":[
							{"resourceName":"Plank",	"amountRequired":1},
							{"resourceName":"Gear",	"amountRequired":1},
							{"resourceName":"Cobble",	"amountRequired":1}
						]
					},
					2:{
						"column":1,
						"row":2,
						"prerequisites":[],
						"reference":["metaWorkbench","processesData", "Plank", "outputBuffers"],
						"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":3,	"resourceType":"Solid"},
						"cost":[
							{"resourceName":"Plank",	"amountRequired":2}
						]
					},
					3:{
						"column":2,
						"row":1,
						"prerequisites":[1],
						"reference":["metaWorkbench","processesData", "Plank", "processTime"],
						"info":2,
						"cost":[
							{"resourceName":"Plank",	"amountRequired":3}
						]
					},
					4:{
						"column":2,
						"row":2,
						"prerequisites":[1,2],
						"reference":["metaWorkbench","processesData", "Plank", "outputBuffers"],
						"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":4,	"resourceType":"Solid"},
						"cost":[
							{"resourceName":"Plank",	"amountRequired":4}
						]
					},
					5:{
						"column":3,
						"row":1,
						"prerequisites":[3],
						"reference":["metaWorkbench","processesData", "Plank", "processTime"],
						"info":1.5,
						"cost":[
							{"resourceName":"Plank",	"amountRequired":5}
						]
					},
					6:{
						"column":3,
						"row":2,
						"prerequisites":[4],
						"reference":["metaWorkbench","processesData", "Plank", "outputBuffers"],
						"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":5,	"resourceType":"Solid"},
						"cost":[
							{"resourceName":"Plank",	"amountRequired":6}
						]
					},
					7:{
						"column":4,
						"row":1,
						"prerequisites":[5,6],
						"reference":["metaWorkbench","processesData", "Plank", "processTime"],
						"info":1,
						"cost":[
							{"resourceName":"Plank",	"amountRequired":7}
						]
					}
				},

				"Gear":
				{
					1:{
						"column":1,
						"row":1,
						"prerequisites":[],
						"reference":["metaWorkbench","processesData", "Gear", "processTime"],
						"info":2.5,
						"cost":[
							{"resourceName":"Gear",	"amountRequired":1}
						]
					},
					2:{
						"column":2,
						"row":1,
						"prerequisites":[1],
						"reference":["metaWorkbench","processesData", "Gear", "outputBuffers"],
						"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":3,	"resourceType":"Solid"},
						"cost":[
							{"resourceName":"Gear",	"amountRequired":2}
						]
					},
					3:{
						"column":2,
						"row":2,
						"prerequisites":[],
						"reference":["metaWorkbench","processesData", "Gear", "processTime"],
						"info":2,
						"cost":[
							{"resourceName":"Gear",	"amountRequired":3}
						]
					},
					4:{
						"column":2,
						"row":3,
						"prerequisites":[1],
						"reference":["metaWorkbench","processesData", "Gear", "outputBuffers"],
						"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":4,	"resourceType":"Solid"},
						"cost":[
							{"resourceName":"Gear",	"amountRequired":4}
						]
					},
					5:{
						"column":3,
						"row":1,
						"prerequisites":[2,3],
						"reference":["metaWorkbench","processesData", "Gear", "processTime"],
						"info":1.5,
						"cost":[
							{"resourceName":"Gear",	"amountRequired":5}
						]
					},
					6:{
						"column":3,
						"row":2,
						"prerequisites":[4],
						"reference":["metaWorkbench","processesData", "Gear", "outputBuffers"],
						"info":{"resourceName":"Plank",		"bufferCurrent":0,	"bufferMax":5,	"resourceType":"Solid"},
						"cost":[
							{"resourceName":"Gear",	"amountRequired":6}
						]
					},
					7:{
						"column":4,
						"row":1,
						"prerequisites":[5,6],
						"reference":["metaWorkbench","processesData", "Gear", "processTime"],
						"info":1,
						"cost":[
							{"resourceName":"Gear",	"amountRequired":7}
						]
					}
				}
		},

}


