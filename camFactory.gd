extends Camera2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var ctnFactoryViewport = Globals.get_node("FactoryNode/ctnFactoryViewport")
onready var vp_dim = get_parent().size
onready var fs_dim = get_node("../FactorySpace").rect_size
onready var ctrlFactoryFloor = get_parent().get_node("ctrlFactoryFloor")

var target_return_enabled = false
var target_return_rate = 0.02
var zoomMin = 0.05
var zoomMax = 1.0
var zoomSensitivity = 10
var zoomSpeed = 0.05
var dragDistance = 1.0
var lastDragDistance = 1.0
var zoomModifier = 1.0

var vertical_offset = 32.0

var zoomStart = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]

var events = {}

export var ZoomSpeed = 50.0
export var ZoomMargin = 0.1

var ZoomPos = Vector2()
var ZoomFactor = 1.0

func PerformZoom(focusPoint):
	
	# Handle the zoom
	# Determine the zoom modifier (i.e. >1 for zooming out OR <1 for zooming in)
	zoomModifier = (1 + zoomSpeed) if dragDistance < lastDragDistance else (1 - zoomSpeed)
	zoomModifier = clamp(zoom.x * zoomModifier, zoomMin, zoomMax) # Bound the zoomModifier
	zoom = Vector2.ONE * zoomModifier # Apply the zoom
	lastDragDistance = dragDistance # Update the previous dragDistance
	
	# Handle the camera move
	var vectorToFocusPoint = focusPoint - position
	position += vectorToFocusPoint/zoomModifier

func clampCameraPosition():
	if Globals.moveStructureMode != "moving":
		# Ensure the user can't drag the camera past the LEFT or RIGHT border
		position.x = clamp( position.x , (vp_dim[0] / 2) * zoom.x , fs_dim[0] - ((vp_dim[0] / 2) * zoom.x) )
		position.y = clamp( position.y , (vp_dim[1] / 2) * zoom.y , fs_dim[1] - ((vp_dim[1] / 2) * zoom.y) )
	else:
		position.x = clamp( position.x , 0 , fs_dim[0] )
		position.y = clamp( position.y , vertical_offset , fs_dim[1] )

func _ready():

	limit_right = fs_dim[0] # Limit the position of the camera
	limit_bottom = fs_dim[1]
	zoomMax = fs_dim[0]/vp_dim[0]
	zoom *= zoomMax
	position = Vector2.ZERO
	clampCameraPosition()

func _process(delta):
		
	zoom.x = lerp(zoom.x, zoom.x * ZoomFactor, ZoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * ZoomFactor, ZoomSpeed * delta)

	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	clampCameraPosition()

func _input(event):


	# Don't process input if the menu is open  OR  if we are drawing conveyors
	if Globals.isMenuOpen == true or Globals.drawConveyorMode != "off":
		return

	get_node("Label").text = ""

	# Don't process input if the input was outside of the viewport
	if event.position[0] < 0 or event.position[1] < 0 or event.position[0] > ctnFactoryViewport.rect_size[0] or event.position[1] > ctnFactoryViewport.rect_size[1]:
		return

	if Globals.spawnResourceMode == true:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_LEFT:
					ctrlFactoryFloor.spawnResource(["Resource"], position,"Coal")
		return


	if Globals.moveStructureMode == "moving":
		drag_margin_h_enabled = true
		drag_margin_v_enabled = true
	else:
		drag_margin_h_enabled = false
		drag_margin_v_enabled = false



	if event is InputEventScreenTouch:

		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)



	elif event is InputEventScreenDrag:

		events[event.index] = event

		# The user is dragging ONE finger across the viewport (DRAG)
		if events.size() == 1:
			if Globals.moveStructureMode == "moving":
				position += event.relative * zoom # Move the camera with the drag
			else:
				position -= event.relative * zoom # Move the camera away from drag

		# The user is dragging TWO fingers across the viewport (ZOOM)
		elif events.size() == 2:

			if Vector2.ZERO in zoomStart: # If this is the first TWO finger event since the last event
				zoomStart = [events[0].position,events[1].position,zoom]

			#var zoomCenter = (events[0].position + events[1].position)/2 # Get the center current finger positions
			var startDistance = (zoomStart[0]-zoomStart[1]).length()
			var currentDistance = (events[0].position-events[1].position).length()
			get_node("Label").text += "\n start: " + str(startDistance) + "\n current: " + str(currentDistance) + "\n"
			#position = zoomCenter
			zoom = zoomStart[2] * startDistance/currentDistance

		if events.size() != 2: # If there aren't two fingers on the screen
			zoomStart[0] = Vector2(0,0)
			zoomStart[1] = Vector2(0,0)
			zoomStart[2] = zoom


	get_node("Label").text += "\nzoomStart: " + str(zoomStart) + "\n Events: \n" + str(events)

	#ScrollWhell Zoom
#	if abs(ZoomPos.x - get_global_mouse_position().x) > ZoomMargin:
#		ZoomFactor = 1.0
#	if abs(ZoomPos.y - get_global_mouse_position().y) > ZoomMargin:
#		ZoomFactor = 1.0

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				ZoomFactor -= 0.02
				ZoomPos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				ZoomFactor += 0.02
				ZoomPos = get_global_mouse_position()

	clampCameraPosition()
