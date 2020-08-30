extends Node2D

var processorBank = {
	
	# PROCESSORS
	"metaTree":{
		
		"nameID":
			"Tree",
		
		"processesData":{
			0:{
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
			0:{
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
			0:{
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
			0:{
				"inputBuffers":[],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Hemp",		"bufferCurrent":0,	"bufferMax":2,	"resourceType":"Solid"}
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
			0:{
				"inputBuffers":[
					{"resourceName":"Clay",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":4,
				"outputBuffers":[
					{"resourceName":"Brick",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			},
		},
		
		"costData":[
			{"resourceName":"Cobble",	"amountRequired":4}
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
			0:{
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
			0:{
				"inputBuffers":[
					{"resourceName":"Log",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Plank",	"bufferCurrent":0,	"bufferMax":2,	"resourceType":"Solid"}
				]
			},
			1:{
				"inputBuffers":[
					{"resourceName":"Plank",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				],
				"processTime":3,
				"outputBuffers":[
					{"resourceName":"Gear",		"bufferCurrent":0,	"bufferMax":2,	"resourceType":"Solid"}
				]
			}
		},
		
		"costData":[
			{"resourceName":"Log",	"amountRequired":2}
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
			0:{
				"inputBuffers":[
					{"resourceName":"Ironore",	"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
					{"resourceName":"Coal",		"bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"},
				],
				"processTime":8,
				"outputBuffers":[
					{"resourceName":"Ironclump","bufferCurrent":0,	"bufferMax":1,	"resourceType":"Solid"}
				]
			},
			1:{
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
			0:{
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
	
	["Stone",		"Solid"],
	
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
	
	["Power",		"Power"]
	
	]





