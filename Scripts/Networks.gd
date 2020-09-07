extends Node

var load_objNetwork = preload("res://Scenes/FactoryScene/objNetwork.tscn")
var networkArray = {}

func getLowestID(noOfIDs=1):
	
	var takenIDs = []
	for netID in networkArray:
		takenIDs.append(netID)
	
	var IDs = []
	if not(takenIDs.empty()):
		takenIDs.sort()
		var ID = 0
		while IDs.size() < noOfIDs:
			if not(ID in takenIDs):
				IDs.append(ID)
			ID += 1
	else:
		IDs.append(0)
	
	if noOfIDs == 1:
		return IDs[0]
	else:
		return IDs

func instanceNetwork(entityList,networkType):
	
	var newID = getLowestID()
	networkArray[newID] = {"Connector":[], "Structure":[], "tilePaths":{}, "type":networkType}
	for entity in entityList:
		addToNetwork(entity,newID)
	
	return newID

func mergeNetworks(alphaID,betaID):
	
	if not(networkArray.has(betaID)): # If the network we're overwriting has already been overwritten
		return
	
	for entity in networkArray[betaID]["Structure"]+networkArray[betaID]["Connector"]:
		entity.removeNetworkID(betaID)
		addToNetwork(entity,alphaID)
	
	networkArray.erase(betaID)

func deleteNetworks(netIDs,deleteStructNetsOnly=false):
	for netID in netIDs:
		var network = networkArray[netID]
		for entity in network["Structure"]+network["Connector"]:
			if deleteStructNetsOnly and network["type"] != "Structure": # If we're not supposed to delete this
				continue # Don't
			removeFromNetwork(entity,[netID])
	

func addToNetwork(nodeToAdd,netID):
	nodeToAdd.addNetworkID(netID)
	if not(nodeToAdd in networkArray[netID][nodeToAdd.entityType]):
		networkArray[netID][nodeToAdd.entityType].append(nodeToAdd)
	nodeToAdd.updateUI()
	updatePaths([netID])

func removeFromNetwork(nodeToRemove,netIDList):
	for netID in netIDList:
		nodeToRemove.removeNetworkID(netID)
		networkArray[netID][nodeToRemove.entityType].erase(nodeToRemove)
		updatePaths([netID])
		if (networkArray[netID]["Structure"]+networkArray[netID]["Connector"]).empty():
			networkArray.erase(netID)

func unpulseNetworks(netIDs):
	for netID in netIDs:
		for entity in networkArray[netID]["Structure"]+networkArray[netID]["Connector"]:
			entity.pulsed = false

func updatePaths(netIDs):
	
	for netID in netIDs:
		
		#print("\n\nNew Paths")
		networkArray[netID]["tilePaths"] = {}
		
		for structure in networkArray[netID]["Structure"]: # For every structure
			#var uncharted = (networkArray[netID]["Structure"]+networkArray[netID]["Connector"]).duplicate()
			var uncharted = []
			var border = [structure]
			var charted = []
			structure.pulseList = []
			while not(border.empty()):
				for entity in border: # For each entity we just charted
					for io in entity.ioList: # For each entity its connected to
						var newEntity = io["tile"].fatherNode
						if netID in newEntity.networkIDs: # If the entity is part of our network
							if entity == structure:
								newEntity.pulseList = [ io["self"] , io["tile"] ]
								uncharted.append(newEntity)
							elif not(newEntity in charted or newEntity in border):
								newEntity.pulseList = entity.pulseList + [io["tile"]]
								uncharted.append(newEntity)
				charted = (charted + border).duplicate()
				border = uncharted.duplicate()
				uncharted = []
			
			networkArray[netID]["tilePaths"][structure] = {}
			for target_structure in networkArray[netID]["Structure"]:
#				print("\nFrom: ",structure.entityName," | To: ",target_structure.entityName)
#				for tile in target_structure.pulseList:
#					print(tile.fatherNode.name," | ",tile.name)
				networkArray[netID]["tilePaths"][structure][target_structure] = target_structure.pulseList.duplicate()













