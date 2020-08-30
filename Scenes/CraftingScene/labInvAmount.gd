extends Label


func updateUI():
	
	self.text = str(Inventory.entityInv[self.owner.entityData["nameID"]])
	
	pass
