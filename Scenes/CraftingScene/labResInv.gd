extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateUI():
	
	self.text = str(Inventory.resourceInv[get_parent().localCostInfo["resourceName"]])
	
	pass
