extends TouchScreenButton

var resAmount = 0

onready var labAddBuilding = get_tree().get_root().get_node("Game/Globals/TopBarNode/btnAddBuilding/labAddBuilding")

func _ready():
	pass

func _process(_delta):
	get_node("../labResource").text = str(resAmount)

func _on_btnProcess_released():
	resAmount += 1

