extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var screenNames = ["Factory","Crafting","Upgrades","Research","Events","Quests","Populace","Settings"]
var currentScreen = 0

func _process(_delta):
	var screenRow = currentScreen/4
	var screenCol = currentScreen%4
	move(Vector2(-screenCol*1080,-screenRow*1920))

func move(target):
	var nodeTween = get_node("twnBottomBar")
	nodeTween.interpolate_property(Globals, "position", Globals.position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

func updateButtonUIs():
	for screenID in range(screenNames.size()):
		if currentScreen == screenID: # If this is the menu we're now on
			get_node("btn"+screenNames[screenID]+"Floor/texButton").texture = load("res://Sprites/Buttons/BottomBar/img_"+screenNames[screenID].to_lower()+"_on.png")
		else:
			if screenNames[screenID] != null:
				get_node("btn"+screenNames[screenID]+"Floor/texButton").texture = load("res://Sprites/Buttons/BottomBar/img_"+screenNames[screenID].to_lower()+"_off.png")

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

