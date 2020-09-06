extends TextureButton

onready var Tab = get_parent().get_parent().get_parent().get_parent()
var load_upgPopup = preload("res://Scenes/UpgradesScene/upgPopup.tscn")
var data

func _ready():
	pass


func _on_node_pressed():
	
	var upgPopup = load_upgPopup.instance()
	upgPopup.configure(data)
	add_child(upgPopup)
	upgPopup.popup_centered()

func purchasedUpgrade():
	
	if data["acquired"] == true:
		return
	
	if data.has("cost"):
		var canUpgrade = true
		for prereq in data["prerequisites"]:
			if Tab.nodes[prereq-1].data["acquired"] == false:
				canUpgrade = false
		if canUpgrade == true:
			if Inventory.spendResources(data["cost"]) == true:
				texture_normal = load("res://Assets/icon_done.png")
				data["acquired"] = true
				Tab.applyUpgrade(data["ID"])
				for child in get_children():
					if "Line" in child.name:
						child.default_color = Color(0.18, 0.55, 0.34, 1)
		else:
			print("not enough resources")

