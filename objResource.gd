extends Node2D

onready var tmpinnerCollisionCircle = get_node("innerCollisionCircle")
onready var tmpouterCollisionCircle = get_node("outerCollisionCircle")
onready var tmpSprite = get_node("Sprite")


# Called when the node enters the scene tree for the first time.
func _ready():
	position += Vector2(32, 48)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
