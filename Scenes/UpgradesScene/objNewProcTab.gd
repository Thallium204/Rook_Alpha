extends Tabs

var load_objCostRes = preload("res://Scenes/CraftingScene/objCostRes.tscn")
var load_objUpgradesTab = preload("res://Scenes/UpgradesScene/objUpgradesTab.tscn")

var entityData
var metaParent
var isUpgrading:bool = false
var timer_upgradingTime = 0.0 # Current timer

func configure(input_entityData, input_metaParent):
	entityData = input_entityData
	metaParent = MetaData.processorBank[input_metaParent]
	if entityData.has("upgCost"):
		for upgCostInfo in entityData["upgCost"]:
			var objCostRes = load_objCostRes.instance()
			$ctnHBox/ctnVBox1.add_child(objCostRes)
			objCostRes.configure(upgCostInfo)
	pass

func _process(delta):
	
	if isUpgrading and entityData.has("upgTime"):
		timer_upgradingTime += delta
		if entityData["upgTime"] <= timer_upgradingTime:
			isUpgrading = false
			timer_upgradingTime = 0
			var objUpgradesTab = load_objUpgradesTab.instance()
			objUpgradesTab.name = entityData["name"]
			get_parent().add_child(objUpgradesTab)
			objUpgradesTab.configure(entityData)
			metaParent["processesData"][metaParent["processesData"].size()] = entityData["info"]
			queue_free()
		
		var progPerc = timer_upgradingTime/float(entityData["upgTime"])
		$ctnHBox/ctnUpgProgress/prgBar.value = stepify(100*progPerc,0.1)

func _on_btnUpg_pressed():
	if entityData.has("upgCost"):
		if Inventory.spendResources(entityData["upgCost"]) == true:
			isUpgrading = true
