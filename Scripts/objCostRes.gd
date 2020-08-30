extends HBoxContainer

var localCostInfo

func configure(costInfo):
	localCostInfo = costInfo
	$labResAmount.text = "/" + str(costInfo["amountRequired"])
	$texResImg.texture = load("res://Assets/Resources/img_" + costInfo["resourceName"].to_lower() + ".png")
	pass

func updateUI():
	
	$labResInv.text = str(Inventory.resourceInv[localCostInfo["resourceName"]])
