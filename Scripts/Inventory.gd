extends Node

var entityInv = {
	
	"Tree":1,
	"Quarry":1,
	"River":1,
	"Plant":1,
	"Hole":3,
	
	"Slow":6,
	"Standard":6,
	"Fast":6,
	"Rapid":6
	
}

var entityList = [
	MetaData.processorBank,
	MetaData.holderBank,
	MetaData.enhancerBank,
	MetaData.conveyorBank,
	MetaData.pipeBank,
	MetaData.cableBank
]

func _ready():
	
	for entityBank in entityList:
		for entity in entityBank:
			var nameID = entityBank[entity]["nameID"]
			if not(entityInv.has(nameID)):
				entityInv[nameID] = 0
	

