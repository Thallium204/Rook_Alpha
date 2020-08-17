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
			[1,1],
			[1,1]
		
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
		
		"shapeData":[
			[1,1],
			[1,1]
		]},
	"metaWorkbench":{
		
		"nameID":
			"Workbench",
		
		"processesData":{
			0:{
				"inputBuffers":[
					{"resourceName":"Log",		"bufferCurrent":1,	"bufferMax":1,	"resourceType":"Solid"}
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
		
		"shapeData":[
			[1],
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
			{"resourceName":"",			"bufferCurrent":0,	"bufferMax":4,	"resourceType":"Solid"}
		],
		
		"shapeData":[
			[1,1]
		]},
	"metaHole2":{
		
		"nameID":
			"Hole2",
		
		"internalStorage":[
			{"resourceName":"",			"bufferCurrent":0,	"bufferMax":4,	"resourceType":"Solid"}
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
	
	"metaStandard":{
		
		"nameID":
			"Standard",
		
		"conveyorSpeed":
			0.5},
	
	"metaSlow":{
		
		"nameID":
			"Slow",
		
		"conveyorSpeed":
			0.2},
	
	"metaFast":{
		
		"nameID":
			"Fast",
		
		"conveyorSpeed":
			1},
	
	"metaRapid":{
		
		"nameID":
			"Rapid",
		
		"conveyorSpeed":
			2}
	
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






