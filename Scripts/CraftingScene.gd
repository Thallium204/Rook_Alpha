extends Control

onready var Game = get_tree().get_root().get_node("Game")
onready var crafting_tree = get_node("ctnCraftingViewport/vptCraftingScene/ctrlCraftingFloor/Tree")

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = crafting_tree.create_item()
	root.set_text(0, "root")
	crafting_tree.set_hide_root(true)	
	var First_Age= crafting_tree.create_item(root)
	var Second_Age = crafting_tree.create_item(root)
	var Third_Age = crafting_tree.create_item(root)
	var Fourth_Age = crafting_tree.create_item(root)
	

	First_Age.set_text(0, "First Age")
	Second_Age.set_text(0, "Second Age")
	Third_Age.set_text(0, "Third Age")
	Fourth_Age.set_text(0, "Fourth Age")
	
	#Game.processor_bank
	
	
	
	#crafting_tree.set_column_title()
	#crafting_tree.set_column_expand(0, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
