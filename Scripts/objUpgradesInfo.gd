extends TabContainer

onready var twnTabInfo = get_node("twnTabInfo")

var tabInfoPosList = [Vector2(976,60), Vector2(976, 354)]
var load_objUnlockedTab = preload("res://Scenes/UpgradesScene/objUnlockedTab.tscn")
var load_objLockedTab = preload("res://Scenes/UpgradesScene/objLockedTab.tscn")

func _ready():
	rect_size = tabInfoPosList[0]

func configure(entityData, _imageDirectory):
	
	# Create all unlocked processes
	for processName in entityData["processesData"]:
		instanceUnlockedTab(entityData["nameID"], processName)
	
	# Create all locked processes
	if entityData.has("lockedProcesses"):
		for processName in entityData["lockedProcesses"]:
			instanceLockedTab(entityData["nameID"], processName, entityData["lockedProcesses"][processName])
	
	visible = false

func instanceUnlockedTab(entityName,procName): # e.g. createUnlocked("Workbench","Plank")
	var objUnlockedTab = load_objUnlockedTab.instance()
	objUnlockedTab.name = procName
	add_child(objUnlockedTab)
	if MetaData.upgradesBank.has(entityName):
		var upgData = MetaData.upgradesBank[entityName][procName]
		objUnlockedTab.configure(entityName, procName, upgData)

func instanceLockedTab(entityName,procName,procData):
	var objLockedTab = load_objLockedTab.instance()
	add_child(objLockedTab)
	objLockedTab.configure(entityName, procName, procData)

func toggleVisible(isCollapsed):
	
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	visible = isCollapsed
	twnTabInfo.interpolate_property(self, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	twnTabInfo.start()
