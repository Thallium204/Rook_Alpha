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

var factoryEntities = {
	"Processor":[],
	"Holder":[],
	"Enhancer":[],
	"Conveyor":[],
	"Pipe":[],
	"Cable":[]
}

var resourceInv = {
	
}

var bufferList = []

func _ready():
	
	for entityBank in entityList:
		for entity in entityBank:
			var nameID = entityBank[entity]["nameID"]
			if not(entityInv.has(nameID)):
				entityInv[nameID] = 0
	
	for resourceData in MetaData.resourceBank:
		resourceInv[resourceData[0]] = 0

func _process(_delta):
	
	for resName in resourceInv:
		resourceInv[resName] = 0
	
	for buffer in bufferList:
		if buffer["resourceName"] == "":
			continue
		resourceInv[buffer["resourceName"]] += buffer["bufferCurrent"]

func addEntityRef(entityRef):
	entityInv[ entityRef.entityName ] -= 1
	factoryEntities[ entityRef.entityClass ].append(entityRef)
	if entityRef.entityClass == "Holder":
		for internalBuffer in entityRef.internalStorage:
			bufferList.append(internalBuffer)

func removeEntityRef(entityRef):
	entityInv[ entityRef.entityName ] += 1
	factoryEntities[ entityRef.entityClass ].erase(entityRef)
	if entityRef.entityClass == "Holder":
		for internalBuffer in entityRef.internalStorage:
			bufferList.erase(internalBuffer)

func getBuffers(resName):
	var buffers = []
	for buffer in bufferList:
		if buffer["resourceName"] == resName:
			buffers.append(buffer)
	return buffers

func spendResources(costData):
	
	for resCostData in costData:
		var cost = resCostData["amountRequired"]
		var buffers = getBuffers(resCostData["resourceName"])
		var bufferIndex = 0
		while cost != 0:
			var buffer = buffers[bufferIndex]
			buffer["bufferCurrent"] -= 1


