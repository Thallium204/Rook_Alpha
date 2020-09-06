extends HBoxContainer

var costInfo # = { "name":? , "cost":? }

func configure(indCostInfo):
	costInfo = indCostInfo
	$texResImg.texture = load("res://Assets/Resources/img_" + costInfo["name"] + ".png")
	$labResAmount.text = "/" + str(costInfo["cost"])

func updateUI():
	
	var resAmount = Inventory.resourceInv[costInfo["name"]]
	
	$labResInv.text = str(resAmount)
	
	if resAmount < costInfo["cost"]:
		$labResInv.add_color_override("font_color", Color(0.7,0.3,0.3))
	else:
		$labResInv.add_color_override("font_color", Color(0.3,0.7,0.3))
