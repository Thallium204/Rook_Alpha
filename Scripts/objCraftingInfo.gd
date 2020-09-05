extends Control

onready var ctnCostInfo = get_node("HBoxContainer/ctnCostInfo")

var entityData
var load_objCostRes = preload("res://Scenes/CraftingScene/objCostRes.tscn")

var timer_craftingTime = 0.0 # Current timer
var isCrafting = false

func _ready():
	rect_size = rect_min_size

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
	visible = isCollapsed


func _on_btnCraft_pressed():
	if entityData.has("costData"):
		if Inventory.spendResources(entityData["costData"]) == true:
			isCrafting = true

func updateUI():
	
	$HBoxContainer/texEntity/labInvAmount.text = str(Inventory.entityInv[entityData["nameID"]])
	if Inventory.hasResources(entityData["costData"]) and not(isCrafting):
		$HBoxContainer/ctnCraftProgress/btnCraft.disabled = false
	else:
		$HBoxContainer/ctnCraftProgress/btnCraft.disabled = true
