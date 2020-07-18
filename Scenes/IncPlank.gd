extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resPlank = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_IncPlank_pressed():
	resPlank += 1
	get_node("ResPlank").text = str(resPlank)
