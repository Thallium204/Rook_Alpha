extends NinePatchRect

var menuResultNode = null	# This node has a menuResult(result,menuID) function
var menuID = ""				# This uniquely references what menu is passing the result

func updatePosition(floorRect,entitySize,zoomLevel):
	
	rect_scale = Vector2.ONE * zoomLevel
	
	rect_position[0] = 0 # Align the Confirm Menu with the left of the structure
	if menuResultNode.position[1] + entitySize[1] + zoomLevel*rect_size[1] > floorRect[1]:
		rect_position[1] = -(entitySize[1]+rect_size[1]+128)*zoomLevel # Put the Confirm Menu above the structure
	else: # If there is space for the Confirm Menu below the structure
		rect_position[1] = entitySize[1] # Put the Confirm Menu below the structure

func _on_btnYes_released():
	menuResultNode.menuResult(menuID,true)

func _on_btnNo_released():
	menuResultNode.menuResult(menuID,false)
