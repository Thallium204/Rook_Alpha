extends NinePatchRect

onready var nodeTweenExpandTab = get_node("twnExpandTab")
onready var nodeTweenTabInfo = get_node("ctnTabInfo/twnTabInfo")
onready var btnExpand = get_node("btnExpand")
onready var ctnTabInfo = get_node("ctnTabInfo")

var isCollapsed:bool = true

var tabPosList = [rect_min_size, rect_min_size + Vector2(0, 384)]
var tabImgList = [load("res://Assets/Buttons/UI/img_tab_down.png"), load("res://Assets/Buttons/UI/img_tab_up.png")]
var tabInfoPosList = [Vector2(920,60), Vector2(920, 364)]

func _ready():
	ctnTabInfo.visible = false
	
	pass # Replace with function body.


func _on_btnExpand_released():
	
	var targetExpandTab = tabPosList[int(isCollapsed)]
	var targetTabInfo = tabInfoPosList[int(isCollapsed)]
	btnExpand.normal = tabImgList[int(isCollapsed)]
	ctnTabInfo.visible = isCollapsed
	isCollapsed = not(isCollapsed)
	nodeTweenExpandTab.interpolate_property(self, "rect_min_size", rect_min_size, targetExpandTab, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTweenExpandTab.start()
	nodeTweenTabInfo.interpolate_property(ctnTabInfo, "rect_size", rect_size, targetTabInfo, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.125)
	nodeTweenTabInfo.start()

