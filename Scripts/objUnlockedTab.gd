extends Tabs

var load_objNode = preload("res://Scenes/UpgradesScene/node.tscn") 
var load_column = preload("res://Scenes/UpgradesScene/column.tscn")
var load_line = preload("res://Scenes/UpgradesScene/line.tscn")

var entityName
var processName
var upgradeData

var nodes = []

var totalColumns = 0
var rowVector = []

var timer = 0

var linesDrawn = false

func configure(input_entityName,input_processName,input_upgradeData):
	entityName = input_entityName
	processName = input_processName
	upgradeData = input_upgradeData
	
	for upgID in upgradeData:
		upgradeData[upgID]["unlocks"] = []
		upgradeData[upgID]["acquired"] = false
		upgradeData[upgID]["ID"] = upgID
		match upgradeData[upgID]["reference"][-1]:
			"processTime": 
				upgradeData[upgID]["tooltip"] = "Decrease process time by " + str(upgradeData[upgID]["info"])
			"bufferMax": 
				upgradeData[upgID]["tooltip"] = "Increase yield by " + str(-1*upgradeData[upgID]["info"])
			"inputBuffers": 
				upgradeData[upgID]["tooltip"] = "Add " + str(processName) + " to input buffer"
			"outputBuffers": 
				upgradeData[upgID]["tooltip"] = "Add " + str(processName) + " to output buffer"
	
	for upgID in upgradeData:
		for prereq in upgradeData[upgID]["prerequisites"]:
			upgradeData[prereq]["unlocks"].append(upgID)
	
	for upgrade in upgradeData.values():
		
		var objNode = load_objNode.instance()
		objNode.data = upgrade
		if upgrade["column"] > totalColumns:
			var colToBuild = upgrade["column"] - totalColumns
			
			for _i in range (0,colToBuild,1):
				var column = load_column.instance()
				column.name = "col" + str(totalColumns+1)
				$ScrollContainer/HBoxContainer.add_child(column)
				rowVector.append(0)
				
			totalColumns = upgrade["column"]
			#print("created " + str(totalColumns) + " new columns")
			
		$ScrollContainer/HBoxContainer.get_node("col" + str(upgrade["column"])).add_child(objNode)
		rowVector[upgrade["column"]-1] += 1
		
		#print(objNode.get_global_transform().get_origin())
		nodes.append(objNode)

func _process(delta):
	timer += delta
	if timer > 0.1 and not(linesDrawn):
		draw_lines()
		linesDrawn = true

func draw_lines():
	
	for entry in nodes:
			
			for prereq in entry.data["unlocks"]:
				
				var node2 = nodes[prereq-1]
				
				var line = load_line.instance()
				line.add_point(Vector2(64,32))
				line.add_point(Vector2(96,32))
				if entry.data["row"] == node2.data["row"] and rowVector[entry.data["column"]-1] == rowVector[node2.data["column"]-1]:
					line.add_point(Vector2(160,32))
				
				match rowVector[entry.data["column"]-1]:
					1:
						match rowVector[node2.data["column"]-1]:
							1:
								line.add_point(Vector2(160, 32))
								line.add_point(Vector2(192, 32))
							2:
								line.add_point(Vector2(160, 32+(32*((node2.data["row"] - 1.5) * 2))))
								line.add_point(Vector2(192, 32+(32*((node2.data["row"] - 1.5) * 2))))
							3:
								line.add_point(Vector2(160, 32 + (node2.data["row"] - 2) * 64))
								line.add_point(Vector2(192, 32 + (node2.data["row"] - 2) * 64))
							_:
								print("Invalid Row Data")
					2:
						match rowVector[node2.data["column"]-1]:
							1:
								line.add_point(Vector2(160, 32+(32*((entry.data["row"] - 1.5) * -2))))
								line.add_point(Vector2(192, 32+(32*((entry.data["row"] - 1.5) * -2))))
							2:
								line.add_point(Vector2(160, 32+(node2.data["row"] - entry.data["row"])*64))
								line.add_point(Vector2(192, 32+(node2.data["row"] - entry.data["row"])*64))
							3:
								line.add_point(Vector2(160, (node2.data["row"] - entry.data["row"])*64))
								line.add_point(Vector2(192, (node2.data["row"] - entry.data["row"])*64))
							_:
								print("Invalid Row Data")
					3:
						match rowVector[node2.data["column"]-1]:
							1:
								line.add_point(Vector2(160, 32 + (entry.data["row"] - 2) * -64))
								line.add_point(Vector2(192, 32 + (entry.data["row"] - 2) * -64))
							2:
								line.add_point(Vector2(160, 64*((node2.data["row"] + 1) - entry.data["row"])))
								line.add_point(Vector2(192, 64*((node2.data["row"] + 1) - entry.data["row"])))
							3:
								line.add_point(Vector2(160, 64 * (node2.data["row"] - entry.data["row"])))
								line.add_point(Vector2(192, 64 * (node2.data["row"] - entry.data["row"])))
							_:
								print("Invalid Row Data")
					_:
						print("Invalid Row Data")
									
				entry.add_child(line)

func applyUpgrade(upgID):
	
	# Get upgrade data
	var pass_upgradeData = {"reference": upgradeData[upgID]["reference"], "info":upgradeData[upgID]["info"]}
	
	# Send it to metaData for new instances
	MetaData.processorBank["meta"+entityName]["upgradeData"].append(pass_upgradeData)
	
	# Send it to existing instances
	for processor in Inventory.factoryEntities["Processor"]:
		if processor.entityName == entityName:
			processor.upgrade(pass_upgradeData)











