extends NinePatchRect

onready var nodeTween = get_node("twnExpandTab")
onready var btnExpand = get_node("btnExpand")
onready var ctnTabInfo = get_node("ctnTabInfo")

var isCollapsed:bool = true

var tabPosList = [rect_min_size, rect_min_size + Vector2(0, 384)]
var tabImgList = [load("res://Assets/Buttons/UI/img_tab_down.png"), load("res://Assets/Buttons/UI/img_tab_up.png")]

func _ready():
	ctnTabInfo.visible = false
	pass # Replace with function body.


func _on_btnExpand_released():
	var target = tabPosList[int(isCollapsed)]
	btnExpand.normal = tabImgList[int(isCollapsed)]
	ctnTabInfo.visible = isCollapsed
	isCollapsed = not(isCollapsed)
	nodeTween.interpolate_property(self, "rect_min_size", rect_min_size, target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

