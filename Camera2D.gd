extends Camera2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var vp_dim = get_parent().size 
onready var fs_dim = get_node("../FactorySceneNode/FactorySpace").rect_size

var target_return_enabled = false
var target_return_rate = 0.02
var zoomMin = 0.5
var zoomMax = 1.0
var zoomSensitivity = 10
var zoomSpeed = 0.05
var dragDistance = 0
var lastDragDistance = 0

var events = {}

export var ZoomSpeed = 50.0
export var ZoomMargin = 0.1

var ZoomPos = Vector2()
var ZoomFactor = 1.0

func PerformZoom(focusPoint):
	
	# Handle the zoom
	# Determine the zoom modifier (i.e. >1 for zooming out OR <1 for zooming in)
	var zoomModifier = (1 + zoomSpeed) if dragDistance < lastDragDistance else (1 - zoomSpeed)
	zoomModifier = clamp(zoom.x * zoomModifier, zoomMin, zoomMax) # Bound the zoomModifier
	zoom = Vector2.ONE * zoomModifier # Apply the zoom
	lastDragDistance = dragDistance # Update the previous dragDistance
	
	# Handle the camera move
	var vectorToFocusPoint = focusPoint - position
	position += vectorToFocusPoint/zoomModifier

func _ready():
	position = vp_dim/2 + Vector2(120,0)
	limit_right = fs_dim[0]
	limit_bottom = fs_dim[1]
	zoomMax = fs_dim[0]/vp_dim[0]
	zoom *= zoomMax
	
func _process(delta):
		
	zoom.x = lerp(zoom.x, zoom.x * ZoomFactor, ZoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * ZoomFactor, ZoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)


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
		
		# The user is dragging ONE finger across the viewport (DRAG)
		if events.size() == 1:
			position -= event.relative * zoom # Move the camera with the drag
		
		# The user is dragging TWO fingers across the viewport (ZOOM)
		elif events.size() == 2:
			var dragVector = events[1].position - events[0].position # Get the vector distance between the two fingers
			dragDistance = dragVector.length() #Get the scalar distance between the two fingers
			var zoomCenter = (events[1].position + events[0].position)/2 # Get the center of the zoom
			# If the users fingers have changed their relative distance by a certain amount (zoomSensitivity)
			if abs(dragDistance - lastDragDistance) >= zoomSensitivity:
				PerformZoom(zoomCenter) # Perform the zoom
		
		# Ensure the user can't drag the camera past the LEFT border
		if position.x < ((vp_dim[0] / 2) * zoom.x):
			position.x = ((vp_dim[0] / 2) * zoom.x)
		# Ensure the user can't drag the camera past the TOP border
		if position.y < ((vp_dim[1] / 2) * zoom.y):
			position.y = ((vp_dim[1] / 2) * zoom.y)
		# Ensure the user can't drag the camera past the RIGHT border
		if position.x > fs_dim[0] - ((vp_dim[0] / 2) * zoom.x):
			position.x = fs_dim[0] - ((vp_dim[0] / 2) * zoom.x)
		# Ensure the user can't drag the camera past the BOTTOM border
		if position.y > fs_dim[1] - ((vp_dim[1] / 2) * zoom.y):
			position.y = fs_dim[1] - ((vp_dim[1] / 2) * zoom.y)
	
	
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
