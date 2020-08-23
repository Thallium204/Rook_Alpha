extends Control

onready var Game = get_tree().get_root().get_node("Game")
onready var crafting_tree = get_node("ctnCraftingViewport/vptCraftingScene/ctrlCraftingFloor/Tree")
var btnCraft = preload("res://Scenes/CraftingScene/Craft_button.tscn")


func _ready():
	crafting_tree.set_columns(1)
	var root = crafting_tree.create_item()
	root.set_text(0, "root")
	crafting_tree.set_hide_root(true)	
	var First_Age= crafting_tree.create_item(root)
	#var Second_Age = crafting_tree.create_item(root)
	#var Third_Age = crafting_tree.create_item(root)
	#var Fourth_Age = crafting_tree.create_item(root)
	
	First_Age.set_text(0, "First Age")
	#Second_Age.set_text(0, "Second Age")
	#Third_Age.set_text(0, "Third Age")
	#Fourth_Age.set_text(0, "Fourth Age")

	for procPos in Game.processorBank:
		if "meta" in procPos:
			var button = load("res://Assets/Buttons/img_craft_off.png")
			var newProc = crafting_tree.create_item(First_Age)
			var metadata = Game.processorBank[procPos]
			newProc.set_collapsed(true)
			newProc.set_metadata(0, metadata)
			newProc.set_text(0, metadata["nameID"])
			if metadata.has("costData"):
				for resCost in metadata["costData"]:
					var newCost = crafting_tree.create_item(newProc)
					newCost.set_text(0, resCost["resourceName"] + " " + str(resCost["amountRequired"]))
				var craftProc = crafting_tree.create_item(newProc)
				
				craftProc.add_button(0, button)
