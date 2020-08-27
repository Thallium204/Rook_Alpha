extends Node2D

onready var Menus = get_tree().get_root().get_node("Game/Menus")

var screenNames = ["Factory","Crafting","Upgrades","Research","Events","Quests","Populace","Settings"]
var currentScreen = 0

func _process(_delta):
	var screenRow = currentScreen/4
	var screenCol = currentScreen%4
	move(Vector2(-screenCol*1080,-screenRow*1920))

func move(target):
	var nodeTween = get_node("twnBottomBar")
	nodeTween.interpolate_property(Menus, "position", Menus.position,  target, 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	nodeTween.start()

func updateButtonUIs():
	
	var scnTxt = screenNames[currentScreen]
	Menus.get_node(scnTxt+"Node").get_node("ctn"+scnTxt+"Viewport").get_node("vpt"+scnTxt+"Scene").get_node("cam"+scnTxt).make_current()
	
	for screenID in range(screenNames.size()):
		if currentScreen == screenID: # If this is the menu we're now on
			get_node("btn"+screenNames[screenID]+"Floor").normal = load("res://Assets/Buttons/BottomBarSquare/img_"+screenNames[screenID].to_lower()+"_on.png")
		else:
			if screenNames[screenID] != null:
				get_node("btn"+screenNames[screenID]+"Floor").normal = load("res://Assets/Buttons/BottomBarSquare/img_"+screenNames[screenID].to_lower()+"_off.png")

func _on_btnFactoryFloor_released():
	currentScreen = 0
	updateButtonUIs()

func _on_btnCraftingFloor_released():
	currentScreen = 1
	updateButtonUIs()

func _on_btnUpgradesFloor_released():
	currentScreen = 2
	updateButtonUIs()

func _on_btnResearchFloor_released():
	currentScreen = 3
	updateButtonUIs()

func _on_btnEventsFloor_released():
	currentScreen = 4
	updateButtonUIs()

func _on_btnQuestsFloor_released():
	currentScreen = 5
	updateButtonUIs()

func _on_btnPopulaceFloor_released():
	currentScreen = 6
	updateButtonUIs()

func _on_btnSettingsFloor_released():
	currentScreen = 7
	updateButtonUIs()

