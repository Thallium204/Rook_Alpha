extends VBoxContainer

var tmpResTab = preload("res://Scenes/FactoryScene/objResTab.tscn")

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	updateArrayList()

func updateArrayList():
	
	# Update resource toals
	for resName in Inventory.resourceInv:
		var objResTab = get_node_or_null(resName+"Tab")
		if objResTab == null:
			objResTab = addResTab(resName,load("res://Assets/Resources/img_"+resName.to_lower()+".png"))
		objResTab.resTotal = Inventory.resourceInv[resName]
	
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
