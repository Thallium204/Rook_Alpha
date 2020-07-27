extends Camera2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var vp_dim = get_parent().size 

var target_return_enabled = false
var target_return_rate = 0.02
var min_zoom = 0.5
var max_zoom = 2
var zoom_sensitivity = 10
var zoom_speed = 0.05

var events = {}
var last_drag_distance = 0

export var ZoomSpeed = 50.0
export var ZoomMargin = 0.1

export var ZoomMin = 0.5
export var ZoomMax = 3.0

var ZoomPos = Vector2()
var ZoomFactor = 1.0


func _ready():
	position = vp_dim/2
	
func _process(delta):
	
		
	zoom.x = lerp(zoom.x, zoom.x * ZoomFactor, ZoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * ZoomFactor, ZoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, ZoomMin, ZoomMax)
	zoom.y = clamp(zoom.y, ZoomMin, ZoomMax)


func _input(event):
	if Globals.isMenuOpen == true:
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)

	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			position -= event.relative * zoom.x
			if position.x < ((vp_dim[0] / 2) * zoom.x):
				position.x = ((vp_dim[0] / 2) * zoom.x)
			if position.y < ((vp_dim[1] / 2) * zoom.y):
				position.y = ((vp_dim[1] / 2) * zoom.y)
		elif events.size() == 2:
			var drag_distance = events[0].position.distance_to(events[1].position)
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
				new_zoom = clamp(zoom.x * new_zoom, min_zoom, max_zoom)
				zoom = Vector2.ONE * new_zoom
				last_drag_distance = drag_distance
				
	#ScrollWhell Zoom
	if abs(ZoomPos.x - get_global_mouse_position().x) > ZoomMargin:
		ZoomFactor = 1.0
	if abs(ZoomPos.y - get_global_mouse_position().y) > ZoomMargin:
		ZoomFactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				ZoomFactor -= 0.02
				ZoomPos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				ZoomFactor += 0.02
				ZoomPos = get_global_mouse_position()
