extends HBoxContainer

var costInfo # = { "resourceName":? , "amountRequired":? }

func configure(indCostInfo):
	costInfo = indCostInfo
	$texResImg.texture = load("res://Assets/Resources/img_" + costInfo["resourceName"].to_lower() + ".png")
	$labResAmount.text = "/" + str(costInfo["amountRequired"])

func updateUI():
	
	var resAmount = Inventory.resourceInv[costInfo["resourceName"]]
	
	$labResInv.text = str(resAmount)
	
	if resAmount < costInfo["amountRequired"]:
		$labResInv.add_color_override("font_color", Color(0.7,0.3,0.3))
	else:
		$labResInv.add_color_override("font_color", Color(0.3,0.7,0.3))
