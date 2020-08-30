extends HBoxContainer

var localCostInfo

func _ready():
	pass # Replace with function body.

func configure(costInfo):
	localCostInfo = costInfo
	$labResAmount.text = "/" + str(costInfo["amountRequired"])
	$texResImg.texture = load("res://Assets/Resources/img_" + costInfo["resourceName"].to_lower() + ".png")
	pass
