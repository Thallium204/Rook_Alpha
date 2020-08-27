extends VBoxContainer

onready var sceneName = owner.sceneName

var objMenuTab = preload("res://Scenes/objMenuTab.tscn")

func _ready():
	for metaProc in MetaData.processorBank:
		var newMenuTab = objMenuTab.instance()
		var imageDirectory = "res://Assets/FactoryEntity/Structure/Processor"
		newMenuTab.configure(sceneName,MetaData.processorBank[metaProc],imageDirectory)
		add_child(newMenuTab)
