extends TouchScreenButton

var resAmount = 0

func _ready():
	pass

func _process(_delta):
	get_node("../labResource").text = str(resAmount)

func _on_btnProcess_released():
	resAmount += 1

