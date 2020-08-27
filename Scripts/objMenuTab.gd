extends NinePatchRect

onready var nodeTweenExpandTab = get_node("twnExpandTab")
onready var btnExpand = get_node("btnExpand")
onready var daddyNode = get_parent().get_parent().get_parent().get_parent()

var nodeTweenTabInfo
var sceneName
var infoTab
var isCollapsed:bool = true

var tabPosList = [rect_min_size, rect_min_size + Vector2(0, 384)]
var tabImgList = [load("res://Assets/UI/img_tab_down.png"), load("res://Assets/UI/img_tab_up.png")]


func _ready():
	
	sceneName = owner.sceneName
	texture = load("res://Assets/UI/img_" + sceneName.to_lower() + "_nine.png")
	var temp = str("res://Scenes/" + sceneName + "Scene/obj" + sceneName + "Info.tscn")
	var objMenuInfo = load(temp)
	infoTab = objMenuInfo.instance()
	infoTab.visible = false
	infoTab.get_node("twnTabInfo")
	add_child(infoTab)
	


func _on_btnExpand_released():
	
	var targetExpandTab = tabPosList[int(isCollapsed)]
	btnExpand.normal = tabImgList[int(isCollapsed)]
	nodeTweenExpandTab.interpolate_property(self, "rect_min_size", rect_min_size, targetExpandTab, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTweenExpandTab.start()
	
	infoTab.toggleVisible(isCollapsed)
	isCollapsed = not(isCollapsed)
