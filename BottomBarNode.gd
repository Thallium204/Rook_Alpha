extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var templateNode = get_tree().get_root().get_node("Game/templateNode")

var screenNames = ["Factory","Crafting","Upgrades","Research","Events","Quests","Populace","Settings"]
var currentScreen = 0

func _process(_delta):
	var screenRow = currentScreen/4
	var screenCol = currentScreen%4
	move(Vector2(-screenCol*1080,-screenRow*1920))

func move(target):
	var nodeTween = get_node("twnBottomBar")
	nodeTween.interpolate_property(Globals, "position", Globals.position,  target, 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	nodeTween.start()

func updateButtonUIs():
	for screenID in range(screenNames.size()):
		if currentScreen == screenID: # If this is the menu we're now on
			get_node("btn"+screenNames[screenID]+"Floor").normal = load("res://Assets/Buttons/BottomBarSquare/img_"+screenNames[screenID].to_lower()+"_on.png")
		else:
			if screenNames[screenID] != null:
				get_node("btn"+screenNames[screenID]+"Floor").normal = load("res://Assets/Buttons/BottomBarSquare/img_"+screenNames[screenID].to_lower()+"_off.png")

func _on_btnFactoryFloor_released():
	currentScreen = 0
	
	Globals.get_node("FactoryNode").get_node("ctnFactoryViewport").get_node("vptFactoryScene").get_node("camFactory").make_current()
	
	updateButtonUIs()

func _on_btnCraftingFloor_released():
	currentScreen = 1
	
	Globals.get_node("CraftingNode").get_node("ctnCraftingViewport").get_node("vptCraftingScene").get_node("camCrafting").make_current()
	
	updateButtonUIs()

func _on_btnUpgradesFloor_released():
	currentScreen = 2
	
	Globals.get_node("UpgradesNode").get_node("ctnUpgradesViewport").get_node("vptUpgradesScene").get_node("camUpgrades").make_current()
	
	updateButtonUIs()

func _on_btnResearchFloor_released():
	currentScreen = 3
	
	Globals.get_node("ResearchNode").get_node("ctnResearchViewport").get_node("vptResearchScene").get_node("camResearch").make_current()
	
	updateButtonUIs()

func _on_btnEventsFloor_released():
	currentScreen = 4
	
	Globals.get_node("EventsNode").get_node("ctnEventsViewport").get_node("vptEventsScene").get_node("camEvents").make_current()
	
	updateButtonUIs()

func _on_btnQuestsFloor_released():
	currentScreen = 5
	
	Globals.get_node("QuestsNode").get_node("ctnQuestsViewport").get_node("vptQuestsScene").get_node("camQuests").make_current()
	
	updateButtonUIs()

func _on_btnPopulaceFloor_released():
	currentScreen = 6
	
	
	Globals.get_node("PopulaceNode").get_node("ctnPopulaceViewport").get_node("vptPopulaceScene").get_node("camPopulace").make_current()
	updateButtonUIs()

func _on_btnSettingsFloor_released():
	currentScreen = 7
	
	Globals.get_node("SettingsNode").get_node("ctnSettingsViewport").get_node("vptSettingsScene").get_node("camSettings").make_current()
	
	updateButtonUIs()

