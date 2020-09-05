extends Tabs


var load_objNode = preload("res://Scenes/UpgradesScene/node.tscn") 
var load_column = preload("res://Scenes/UpgradesScene/column.tscn")
var load_line = preload("res://Scenes/UpgradesScene/line.tscn")

var treeNodes = {}

var nodes = []

var totalColumns = 0
var rowVector = []

var timer = 0

var flag = false

func configure(input_treeNodes):
	treeNodes = input_treeNodes
	
	for entry in treeNodes.keys():
		treeNodes[entry]["unlocks"] = []
		treeNodes[entry]["acquired"] = false
		if not(treeNodes[entry].has("tooltip")):
			treeNodes[entry]["tooltip"] = "This is a sample upgrade tooltip"
	for entry in treeNodes.keys():
		for prereq in treeNodes[entry]["prerequisites"]:
			treeNodes[prereq]["unlocks"].append(entry)

	
	for entry in treeNodes.keys():
		
		var objNode = load_objNode.instance()
		objNode.data = treeNodes[entry]
		if treeNodes[entry]["column"] > totalColumns:
			var colToBuild = treeNodes[entry]["column"] - totalColumns
			
			for _i in range (0,colToBuild,1):
				var column = load_column.instance()
				column.name = "col" + str(totalColumns+1)
				$ScrollContainer/HBoxContainer.add_child(column)
				rowVector.append(0)
				
			totalColumns = treeNodes[entry]["column"]
			#print("created " + str(totalColumns) + " new columns")
			
		$ScrollContainer/HBoxContainer.get_node("col" + str(treeNodes[entry]["column"])).add_child(objNode)
		rowVector[treeNodes[entry]["column"]-1] += 1
		
		#print(objNode.get_global_transform().get_origin())
		nodes.append(objNode)
	
	pass

func _process(delta):
	timer += delta
	if timer > 0.1 and flag == false:
		draw_lines()
		flag = true
	pass

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

func applyUpgrade(id):
	pass


























