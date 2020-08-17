extends Control


onready var crafting_tree = get_node("ctnCraftingViewport/vptCraftingScene/ctrlCraftingFloor/Tree")

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = crafting_tree.create_item()
	root.set_text(0, "YEET")
	var child1 = crafting_tree.create_item(root)
	var child2 = crafting_tree.create_item(root)
	var child3 = crafting_tree.create_item(root)
	var child4 = crafting_tree.create_item(root)
	child1.set_text(0, "SKEET")
	child2.set_text(0, "SKEET")
	child3.set_text(0, "BANG")
	child4.set_text(0, "BANG")
	var child5 = crafting_tree.create_item(child4)
	child5.set_text(0, "person of color")
	#crafting_tree.set_column_title()
	#crafting_tree.set_column_expand(0, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
