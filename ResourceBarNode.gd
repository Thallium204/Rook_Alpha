extends VBoxContainer

var tmpResTab = preload("res://Scenes/FactoryScene/objResTab.tscn")

var holderArray = []

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	updateArrayList()

func updateArrayList():
	
	for objResTab in get_children():
		objResTab.resTotal = 0
	
	for objHolder in holderArray: # Check all holders
		if objHolder == null:
			holderArray.erase(objHolder)
		else:
			for internalBuffer in objHolder.internalStorage:
				if internalBuffer["resourceName"] != "":
					var objResTab = get_node_or_null(internalBuffer["resourceName"]+"Tab")
					if objResTab == null:
						objResTab = addResTab(internalBuffer["resourceName"],load("res://Assets/Resources/img_"+internalBuffer["resourceName"]+".png"))
					objResTab.resTotal += internalBuffer["bufferCurrent"]
	
	for objResTab in get_children():
		if objResTab.resTotal == 0:
			objResTab.queue_free()
		else:
			objResTab.updateUI()

func addResTab(resName,resTexture):
	var newResTab = tmpResTab.instance()
	newResTab.resName = resName
	newResTab.resTexture = resTexture
	newResTab.name = resName+"Tab"
	add_child(newResTab)
	return newResTab
