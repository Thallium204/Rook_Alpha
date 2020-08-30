extends Control

onready var twnTabInfo = get_node("twnTabInfo")
onready var ctnCostInfo = get_node("HBoxContainer/ctnCostInfo")

var entityData
var tabInfoPosList = [Vector2(920,60), Vector2(920, 374)]
var load_objCostRes = preload("res://Scenes/CraftingScene/objCostRes.tscn")

var timer_craftingTime = 0.0 # Current timer
var isCrafting = false

func _ready():
	rect_size = tabInfoPosList[0]

func configure(input_entityData, imageDirectory):
	
	entityData = input_entityData
	if entityData.has("costData"):
		for costInfo in entityData["costData"]:
			var objCostRes = load_objCostRes.instance()
			get_node("HBoxContainer/ctnCostInfo").add_child(objCostRes)
			objCostRes.configure(costInfo)
	$HBoxContainer/texEntity.texture = load(imageDirectory + "/img_" + entityData["nameID"].to_lower() + ".png")
	visible = false

func _process(delta):
	
	if isCrafting and entityData.has("craftTime"):
		timer_craftingTime += delta
		if entityData["craftTime"] <= timer_craftingTime:
			isCrafting = false
			timer_craftingTime = 0
			Inventory.entityInv[entityData["nameID"]] += 1
		
		var progPerc = timer_craftingTime/float(entityData["craftTime"])
		$HBoxContainer/ctnCraftProgress/prgBar.value = stepify(100*progPerc,0.1)
	
	pass

func toggleVisible(isCollapsed):
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	visible = isCollapsed
	twnTabInfo.interpolate_property(self, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	twnTabInfo.start()


func _on_btnCraft_pressed():
	if entityData.has("costData"):
		if Inventory.spendResources(entityData["costData"]) == true:
			isCrafting = true
	pass # Replace with function body.
