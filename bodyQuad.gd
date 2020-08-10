extends StaticBody2D

var active = false

func _on_bodyQuadU_mouse_entered():
	active = true
	print(active)

func _on_bodyQuadU_mouse_exited():
	active = false
	print(active)


func _on_bodyQuad_input_event(viewport, event, shape_idx):
	print(active)
