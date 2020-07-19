extends GridContainer

func addBuilding(name):
	var newNode = get_node("../texBuilding").duplicate()
	newNode.set_name("tex"+name)
	newNode.texture = load("res://Sprites/img_"+name.to_lower()+".png")
	add_child(newNode)
