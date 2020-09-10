extends "res://Scripts/classFactoryEntity.gd"

onready var direSprites = [$sprU,$sprR,$sprD,$sprL]

func _ready():
	imageDirectory += "/Connector"
	entityType = "Connector"
	add_to_group("Connector")

func updateNetwork():
	# Find the surrounding entities and networks
	var entityList = []
	var potentialNetIDs = []
	for adj in adjacentTileList:
		if adj["tile"].fatherNode != null:
			var checkEntity = adj["tile"].fatherNode
			if checkEntity.entityType == "Connector" and checkEntity.entityClass != entityClass:
				continue # Ignore different classes of connectors
			addIOTile( { "tile":adj["tile"] , "dire":dirConv[adj["vector"]] , "self":adj["self"] } )
			checkEntity.addIOTile( { "tile":adj["self"] , "dire":dirConv[-adj["vector"]] , "self":adj["tile"] } )
			entityList.append(checkEntity)
			if checkEntity.entityType == "Connector":
				if not(checkEntity.networkIDs[0] in potentialNetIDs):
					potentialNetIDs.append(checkEntity.networkIDs[0])
	
	var ourID = 0
	if potentialNetIDs.empty():
		# If we are the start of a new network
		ourID = Networks.instanceNetwork([self],entityClass)
	else:
		# If we're surrounded by one or more networks
		potentialNetIDs.sort()
		ourID = potentialNetIDs[0]
		Networks.addToNetwork(self,ourID)
		for netID in potentialNetIDs:
			if netID == ourID:
				continue
			Networks.mergeNetworks(ourID,netID)
	
	for entity in entityList:
		entity.updateUI()
		if entity.entityType == "Structure":
			Networks.addToNetwork(entity,ourID)
	
	updateUI()

func deleteFromNetwork():
	# Erase our network
	Networks.deleteNetworks(networkIDs)
	
	var newNetworkIDs = []
	for adj in adjacentTileList:
		var checkEntity = adj["tile"].fatherNode
		pulsed = true
		if checkEntity != null:
			if checkEntity.entityType == "Connector":
				var networkList = checkEntity.sendPulse([])
				if networkList != []:
					#print(networkList)
					newNetworkIDs.append( Networks.instanceNetwork(networkList,entityClass) )
				checkEntity.updateUI()
	
	Networks.unpulseNetworks(newNetworkIDs)
	
	updateUI()

func updateUI():
	
	for sprX in direSprites:
		sprX.visible = false
	
	for io in ioList:
		get_node("spr"+io["dire"]).visible = true

func configure_Connector(connectorData):
	
	entityShape = [[1]]
	
	configure_Entity(connectorData)

func onPressed_Connector(tile): # Pressed Processes for all structures
	
	# Handle Entity
	onPressed_Entity(tile)

func onReleased_Connector(tile): # Released Processes for all structures
	
	if Globals.deleteStructureMode == true:
		deleteFromNetwork()
	
	# Handle Entity
	onReleased_Entity(tile)







