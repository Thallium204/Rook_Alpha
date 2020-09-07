extends Node

var entityInv = {
	
	"Hole":5,
	"Hole2":2,
	
	"Dense":16,
	"Normal":64,
	"Vacuum":16,
	"Impulse":32,
	"Warp":8,
	
	"NormalPipe":64
	
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
				entityInv[nameID] = 2
	
	for resourceData in MetaData.resourceBank:
		resourceInv[resourceData] = 0

func _process(_delta):
	
	for resName in resourceInv:
		resourceInv[resName] = 0
	
	for buffer in bufferList:
		if buffer["name"] == "":
			continue
		resourceInv[buffer["name"]] += buffer["current"]
	
	updateInvUI()

func addEntityRef(entityRef): # entityRef = node reference
	entityInv[ entityRef.entityName ] -= 1 # Decrease inventory avaliable
	factoryEntities[ entityRef.entityClass ].append(entityRef) # Add reference
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
		if buffer["name"] == resName:
			buffers.append(buffer)
	return buffers

func spendResources(costData):
	
	if not hasResources(costData):
		return false
	
	for resCostData in costData:
		var cost = resCostData["cost"]
		var buffers = getBuffers(resCostData["name"])
		var bufferIndex = 0
		while cost != 0:
			var buffer = buffers[bufferIndex]
			buffer["current"] -= 1
			buffer["potential"] -= 1
			cost -= 1
			if buffer["current"] == 0:
				buffer["name"] = ""
				buffers.erase(buffer)
	
	return true

func hasResources(costData):
	var haveEnough = true
	for resCostData in costData:
		if resourceInv[resCostData["name"]] < resCostData["cost"]:
			haveEnough = false
	return haveEnough

func updateInvUI():
	var UINodes = get_tree().get_nodes_in_group("grpInvUI")
	
	for UINode in UINodes:
		UINode.call("updateUI")




