extends GridContainer

func _on_btnAdd_released():
	var newNode = get_node("texCobble").duplicate()
	newNode.set_name("dupCobble")
	add_child(newNode)
