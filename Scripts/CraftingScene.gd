extends Control

onready var Game = get_tree().get_root().get_node("Game")
onready var crafting_tree = get_node("ctnCraftingViewport/vptCraftingScene/ctrlCraftingFloor/Tree")

var btnTextureOn = load("res://Assets/Buttons/UI/img_craft_on.png")
var btnTextureOff = load("res://Assets/Buttons/UI/img_craft_off.png")

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
			var procItem = crafting_tree.create_item(First_Age)
			var metadata = Game.processorBank[procPos]
			#procItem.set_collapsed(true)
			procItem.set_metadata(0, metadata)
			procItem.set_text(0, metadata["nameID"])
			if metadata.has("costData"):
				for resCost in metadata["costData"]:
					var costItem = crafting_tree.create_item(procItem)
					costItem.set_text(0, resCost["resourceName"] + " " + str(resCost["amountRequired"]))
				var buttonItem = crafting_tree.create_item(procItem)
				procItem.add_button(0, btnTextureOff)
				print(procItem.get_text(0)," -> ", buttonItem," -> ",buttonItem.get_button(0,0))
				

func _on_Tree_button_pressed(item, column, id):
	if item == null:
		return
	print()
	print (item," = ",item.get_text(0), column, id)
	print (item.get_parent())
	#item.set_button(column, id, btnTextureOn)
	#item.set_text(0,"pressed")
	#OS.delay_msec(500)
	item.set_text(0,"released")
	#item.set_button(column, id, btnTextureOff)
	pass
