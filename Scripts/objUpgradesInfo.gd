extends TabContainer

onready var twnTabInfo = get_node("twnTabInfo")

var tabInfoPosList = [Vector2(976,60), Vector2(976, 354)]
var load_objUpgradesTab = preload("res://Scenes/UpgradesScene/objUpgradesTab.tscn")
var load_objNewProcTab = preload("res://Scenes/UpgradesScene/objNewProcTab.tscn")

func _ready():
	rect_size = tabInfoPosList[0]

func configure(entityData, _imageDirectory):
	for processIndex in entityData["processesData"]:
		var processInfo = entityData["processesData"][processIndex]
		var objUpgradesTab = load_objUpgradesTab.instance()
		objUpgradesTab.name = processInfo["outputBuffers"][0]["resourceName"]
		add_child(objUpgradesTab)
		objUpgradesTab.configure(processIndex)
	
	if entityData.has("upgradeData"):
		for upgIndex in entityData["upgradeData"]:
			match upgIndex["action"]:
				"edit":
					pass
				"add":
					if upgIndex["class"] == "newProc":
						var objNewProcTab = load_objNewProcTab.instance()
						objNewProcTab.name = "_" + upgIndex["name"]
						add_child(objNewProcTab)
						objNewProcTab.configure(upgIndex, "meta" + entityData["nameID"])
					pass
				_:
					pass
	
	
	
	
	visible = false

func toggleVisible(isCollapsed):
	
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	visible = isCollapsed
	twnTabInfo.interpolate_property(self, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	twnTabInfo.start()
