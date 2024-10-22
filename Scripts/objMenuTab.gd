extends NinePatchRect

onready var nodeTweenExpandTab = get_node("twnExpandTab")
onready var btnExpand = get_node("ctnTitle/btnExpand")

var sceneName
var objMenuInfo
var isCollapsed:bool = true

var tabPosList = [rect_min_size, rect_min_size + Vector2(0, 500)]
var tabImgList = [load("res://Assets/UI/img_tab_down.png"), load("res://Assets/UI/img_tab_up.png")]

func configure(scnName, entityData, imageDirectory):
	# Configure Scene Info
	sceneName = scnName
	texture = load("res://Assets/UI/img_" + sceneName.to_lower() + "_nine.png")
	
	# Configure Entity Info
	$ctnTitle/labName.text = entityData["nameID"]
	$ctnTitle/texIcon.texture = load(imageDirectory + "/img_" + entityData["nameID"].to_lower() + ".png")
	
	# Create Info Node
	var load_objMenuInfo = load("res://Scenes/" + sceneName + "Scene/obj" + sceneName + "Info.tscn")
	objMenuInfo = load_objMenuInfo.instance()
	add_child(objMenuInfo)
	objMenuInfo.configure(entityData, imageDirectory)
	

func _on_btnExpand_pressed():
	
	var targetExpandTab = tabPosList[int(isCollapsed)]
	btnExpand.texture_normal = tabImgList[int(isCollapsed)]
	nodeTweenExpandTab.interpolate_property(self, "rect_min_size", rect_min_size, targetExpandTab, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTweenExpandTab.start()
	
	objMenuInfo.toggleVisible(isCollapsed)
	isCollapsed = not(isCollapsed)
