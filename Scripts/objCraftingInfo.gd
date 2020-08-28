extends Control

onready var twnTabInfo = get_node("twnTabInfo")

var tabInfoPosList = [Vector2(920,60), Vector2(920, 374)]

func configure(_entityData):
	visible = false

func toggleVisible(isCollapsed):
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	visible = isCollapsed
	twnTabInfo.interpolate_property(self, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	twnTabInfo.start()
