extends Area2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")

func _ready():
	connect("input_event",self,"_on_bodyWhole_mouse_entered")
	connect("mouse_entered",self,"_on_bodyWhole_mouse_entered")
	connect("mouse_exited",self,"_on_bodyWhole_mouse_exited")

func _on_bodyWhole_mouse_entered(_viewport=null,event=null,_shape=null):
	if Globals.drawConveyorMode == "moving":
		if event == null or event is InputEventScreenTouch:
			get_parent().begin()

func _on_bodyWhole_mouse_exited():
	if Globals.drawConveyorMode == "moving":
		get_parent().end()
