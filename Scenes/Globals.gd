extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_btnStoreLayout_released():
	get_node("FactoryLayout").move(Vector2(1080,0))
	get_node("StoreLayout").move(Vector2(0,0))
	pass # Replace with function body.


func _on_btnFactoryLayout_released():
	get_node("FactoryLayout").move(Vector2(0,0))
	get_node("StoreLayout").move(Vector2(-1080,0))
	pass # Replace with function body.
