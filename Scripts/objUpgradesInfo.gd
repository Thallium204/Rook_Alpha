extends TabContainer

onready var twnTabInfo = get_node("twnTabInfo")

var tabInfoPosList = [Vector2(920,60), Vector2(920, 374)]
var load_objUpgradesTab = preload("res://Scenes/UpgradesScene/objUpgradesTab.tscn")

func _ready():
	rect_size = tabInfoPosList[0]

func configure(entityData):
	for processIndex in entityData["processesData"]:
		var processInfo = entityData["processesData"][processIndex]
		var objUpgradesTab = load_objUpgradesTab.instance()
		objUpgradesTab.name = processInfo["outputBuffers"][0]["resourceName"]
		add_child(objUpgradesTab)
	visible = false

func toggleVisible(isCollapsed):
	
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	visible = isCollapsed
	twnTabInfo.interpolate_property(self, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	twnTabInfo.start()
