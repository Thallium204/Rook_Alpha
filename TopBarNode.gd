extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")

func _process(_delta):
	if Globals.isMenuOpen == false:
		move(Vector2(0,0))
	else:
		move(Vector2(0,384))

func move(target):
	var nodeTween = get_node("btnBuildingMenu/twnTopBarAdd")
	nodeTween.interpolate_property(self, "position", position,  target, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	nodeTween.start()

# TAPPING A TOPBAR OPTION (RELEASE)
func _on_btnBuildingMenu_released():
	pass


func _on_btnBuildingMenu_pressed():
	if Globals.isMenuOpen == false: # If the menu is closed
		Globals.isMenuOpen = true
	else:
		Globals.isMenuOpen = false
