extends PopupPanel

var load_objCostRes = preload("res://Scenes/CraftingScene/objCostRes.tscn")

var data

func configure(input_data):
	data = input_data
	for costIndex in data["cost"]:
		var objCostRes = load_objCostRes.instance()
		objCostRes.configure(costIndex)
		$VBoxContainer/HBoxContainer/VBoxContainer.add_child(objCostRes)
	$VBoxContainer/HBoxContainer/Label.text = data["tooltip"]

func _on_btnUpg_pressed():
	get_parent().call("purchasedUpgrade")
	queue_free()
