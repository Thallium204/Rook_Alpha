extends NinePatchRect

var menuResultNode = null	# This node has a menuResult(result,menuID) function
var menuID = ""				# This uniquely references what menu is passing the result

func _on_btnYes_released():
	menuResultNode.menuResult(menuID,true)

func _on_btnNo_released():
	menuResultNode.menuResult(menuID,false)
