extends VBoxContainer

var tmpResTab = preload("res://Scenes/FactoryScene/objResTab.tscn")

var holderArray = [] # Contains node refs of all holders

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	updateArrayList()

func updateArrayList():
	
	# Reset resource totals
	for objResTab in get_children():
		objResTab.resTotal = 0
	
	# Update resource toals
	for objHolder in holderArray: # Check all holders
		if objHolder == null: # If a reference is null (holder has been deleted) erase it
			holderArray.erase(objHolder)
		else:
			for internalBuffer in objHolder.internalStorage:
				if internalBuffer["resourceName"] != "":
					var objResTab = get_node_or_null(internalBuffer["resourceName"]+"Tab")
					if objResTab == null:
						objResTab = addResTab(internalBuffer["resourceName"],load("res://Assets/Resources/img_"+internalBuffer["resourceName"].to_lower()+".png"))
					objResTab.resTotal += internalBuffer["bufferCurrent"]
	
	# Delete Tabs with no resources
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
