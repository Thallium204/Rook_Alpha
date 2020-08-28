extends Control

onready var twnTabInfo = get_node("twnTabInfo")
onready var ctnCostInfo = get_node("HBoxContainer/ctnCostInfo")

var entityData
var tabInfoPosList = [Vector2(920,60), Vector2(920, 374)]
var load_objCostRes = preload("res://Scenes/CraftingScene/objCostRes.tscn")

func _ready():
	rect_size = tabInfoPosList[0]

func configure(scnName, input_entityData, imageDirectory):
	
	entityData = input_entityData
	if entityData.has("costData"):
		for costInfo in entityData["costData"]:
			var objCostRes = load_objCostRes.instance()
			get_node("HBoxContainer/ctnCostInfo").add_child(objCostRes)
			objCostRes.configure(scnName, costInfo, imageDirectory)
	$HBoxContainer/texEntity.texture = load(imageDirectory + "/img_" + entityData["nameID"].to_lower() + ".png")
	visible = false


func toggleVisible(isCollapsed):
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	visible = isCollapsed
	twnTabInfo.interpolate_property(self, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	twnTabInfo.start()


func _on_btnCraft_pressed():
	if entityData.has("costData"):
		Inventory.spendResources(entityData["costData"])
	pass # Replace with function body.
