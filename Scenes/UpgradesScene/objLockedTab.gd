extends Tabs

var load_objCostRes = preload("res://Scenes/CraftingScene/objCostRes.tscn")
var load_objUnlockedTab = preload("res://Scenes/UpgradesScene/objUnlockedTab.tscn")

var entityName
var processName
var processData

var isUpgrading:bool = false
var timer_upgradingTime = 0.0 # Current timer

func configure(input_entityName,input_processName,input_processData): # lockedProcess = {found in metaData} | entityName = "Workbench"
	entityName = input_entityName
	processName = input_processName
	processData = input_processData
	name = "_" + processName
	if processData.has("upgCost"):
		for upgCostInfo in processData["upgCost"]:
			var objCostRes = load_objCostRes.instance()
			$ctnHBox/ctnVBox1.add_child(objCostRes)
			objCostRes.configure(upgCostInfo)

func _process(delta):
	
	if isUpgrading and processData.has("upgTime"):
		timer_upgradingTime += delta
		if processData["upgTime"] <= timer_upgradingTime:
			applyUnlock()
		
		var progPerc = timer_upgradingTime/float(processData["upgTime"])
		$ctnHBox/ctnUpgProgress/prgBar.value = stepify(100*progPerc,0.1)

func applyUnlock():
	
	isUpgrading = false
	timer_upgradingTime = 0
	
	# Get upgrade data
	var pass_unlockData = {
		"inputBuffers": processData["inputBuffers"],
		"processTime": processData["processTime"],
		"outputBuffers": processData["outputBuffers"]
		}
	
	# Send it to metaData for new instances
	MetaData.processorBank["meta"+entityName]["processesData"][processName] = pass_unlockData
	
	# Send it to existing instances
	for processor in Inventory.factoryEntities["Processor"]:
		if processor.entityName == entityName:
			processor.upgrade(pass_unlockData)
	
	get_parent().instanceUnlockedTab(entityName,processName)
	queue_free()

func _on_btnUpg_pressed():
	if processData.has("upgCost"):
		if Inventory.spendResources(processData["upgCost"]) == true:
			isUpgrading = true
