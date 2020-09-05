extends Node2D

var currentScreen = 0

var isMenuOpen = false

var displayInfoMode = false
var moveStructureMode = "off"		# "off" | "ready" | "moving" 
var drawConnectorMode = "off"		# "off" | "ready" | "touching"
var deleteStructureMode = false
var autoCraft = false

var drawConnector = {"nameID":"Standard","connectorType":"Conveyor"}
var populace = {"total":1,"avaliable":1}
var infoColorModifier = 0.3
var colorList = [Color(1,1,1),
				Color(1,0.2,0.2),Color(0.2,1,0.2),Color(0.2,0.2,1),
				Color(0.2,1,1),Color(1,0.2,1),Color(1,1,0.2),
				Color(0.2,0.2,0.2)]

func _process(_delta):
	pass

func getResourceType(nameID):
	for resource in MetaData.resourceBank:
		if resource[0] == nameID:
			return resource[1]
	return "none"

func getStructureMeta(nameID,structureType):
	if structureType == "Processor":
		return MetaData.processorBank["meta"+nameID].duplicate(true)
	elif structureType == "Holder":
		return MetaData.holderBank["meta"+nameID].duplicate(true)
	elif structureType == "Enhancer":
		return MetaData.enhancerBank["meta"+nameID].duplicate(true)

func getConnectorMeta(nameID,connectorType):
	if connectorType == "Conveyor":
		return MetaData.conveyorBank["meta"+nameID].duplicate(true)
	if connectorType == "Pipe":
		return MetaData.pipeBank["meta"+nameID].duplicate(true)
	if connectorType == "Cable":
		return MetaData.cableBank["meta"+nameID].duplicate(true)

func initialseStructureData(nameID,structureType):
	var structureData = getStructureMeta(nameID,structureType)
	return structureData

func initialseConnectorData():
	if drawConnector["nameID"] == "":
		return
	var connectorData = getConnectorMeta(drawConnector["nameID"],drawConnector["connectorType"])
	return connectorData








