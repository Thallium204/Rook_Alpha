extends Node2D


func move(target):
	var nodeTween = get_node("btnAddBuilding/twnTopBarAdd")
	nodeTween.interpolate_property(self, "position", position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()
