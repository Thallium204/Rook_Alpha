extends TouchScreenButton

onready var FactoryFloor = get_tree().get_root().get_node("Game/Globals/FactoryFloor")

func _on_btnAdd_released():
	var totalName = str(self.name)
	var idName = totalName.substr(6)
	FactoryFloor.addBuilding(idName)
