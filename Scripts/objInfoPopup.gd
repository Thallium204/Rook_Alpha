extends Popup

var load_objProcessStats = preload("res://Scenes/objProcessStats.tscn")
var load_currentTheme = preload("res://Scenes/FactoryScene/FactoryTheme.tres")

var entityData
var lastTab
var maxTabSize = Vector2(0, 0)

func configure(input_entityData):
	
	entityData = input_entityData
	var tab
	var tabContainer = TabContainer.new()
	$Panel.add_child(tabContainer)
	tabContainer.rect_position += Vector2(90, 50)
	tabContainer.set_theme(load_currentTheme)
	for processIndex in entityData["processesData"]:
		tab = Tabs.new()
		tab.set_script(load("res://Scripts/objStatsTab.gd"))
		tab.add_to_group("grpCtnSort")
		var objProcessStats = load_objProcessStats.instance()
		tab.add_child(objProcessStats)
		objProcessStats.configure(entityData["processesData"][processIndex])
		tab.name = processIndex
		tabContainer.add_child(tab)
	#tab.last
	tabContainer.queue_sort()
	

func _on_Control_popup_hide():
	queue_free()


func _on_Button3_pressed():
	queue_free()
