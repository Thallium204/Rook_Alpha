extends Camera2D

export var CameraSpeed = 25.0
export var ZoomSpeed = 50.0
export var ZoomMargin = 0.1

export(float) var panSmooth := -5
export(float) var followSmooth : float

export var ZoomMin = 0.5
export var ZoomMax = 3.0

var ZoomPos = Vector2()
var ZoomFactor = 1.0

var Touches = {}
var TouchesInfo = {"num_touch_last_frame":0, "radius":0, "total_pan":0}
var Bounds = {"x":10800, "y":9600}

var lastCamPos := Vector2(0, 0)
var curVel := Vector2(0, 0)

func _ready():
	pass
	
	
	
	
#func _process(delta):
#
#	#get directional input
#	var inpx = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
#	var inpy = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
#
#	#smoothly interpolate camera panning
#	position.x = lerp(position.x, position.x + inpx * CameraSpeed * zoom.x, CameraSpeed * delta)
#	position.y = lerp(position.y, position.y + inpy * CameraSpeed * zoom.y, CameraSpeed * delta)
#
#	zoom.x = lerp(zoom.x, zoom.x * ZoomFactor, ZoomSpeed * delta)
#	zoom.y = lerp(zoom.y, zoom.y * ZoomFactor, ZoomSpeed * delta)
#
#	zoom.x = clamp(zoom.x, ZoomMin, ZoomMax)
#	zoom.y = clamp(zoom.y, ZoomMin, ZoomMax)
#
#	pass

func _input(event):
	
	if abs(ZoomPos.x - get_global_mouse_position().x) > ZoomMargin:
		ZoomFactor = 1.0
	if abs(ZoomPos.y - get_global_mouse_position().y) > ZoomMargin:
		ZoomFactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				ZoomFactor -= 0.01
				ZoomPos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				ZoomFactor += 0.01
				ZoomPos = get_global_mouse_position()
				
func _UnhandledInput(event):
	if event is InputEventScreenTouch and event.pressed == true:
		Touches[event.index] = {"start":event, "current":event}
	if event is InputEventScreenTouch and event.pressed == false:
		Touches.erase(event.index)
	if event is InputEventScreenDrag:
		if not event.index in Touches:
			Touches[event.index] = {"start":event, "current":event}
		Touches[event.index]["current"] = event
		
func ZoomCamera(dir):
	zoom += Vector2(0.1, 0.1) * dir
	zoom.x = clamp(zoom.x, ZoomMin, ZoomMax)
	zoom.y = clamp(zoom.y, ZoomMin, ZoomMax)
	
func UpdateTouchInfo():
	if Touches.size() <= 0:
		TouchesInfo.num_touch_last_frame = Touches.size()
		TouchesInfo["total_pan"] = 0
		return
	
	if TouchesInfo["num_touch_last_frame"] == 0:
		resetSmooth()
	
	var avgTouch = Vector2(0, 0)
	for key in Touches:
		avgTouch += Touches[key].current.position
	TouchesInfo["cur_pos"] = avgTouch / Touches.size()
	
	if TouchesInfo.num_touch_last_frame != Touches.size():
		TouchesInfo["target"] = TouchesInfo["cur_pos"]
		
	TouchesInfo.num_touch_last_frame = Touches.size()
	
	doMultiTouchPan()

func doMultiTouchPan():
	var diff = TouchesInfo.target - TouchesInfo.cur_pos
	
	var newPos = self.position + (diff * zoom.x)
	
	if newPos.x < 0 or newPos.x > Bounds.x:
		newPos.x = self.position.x
	if newPos.y < 0 or newPos.y > Bounds.y:
		newPos.y = self.position.y
	
	self.position = newPos
	
	TouchesInfo.target = TouchesInfo.cur_pos


func updatePinchGesture():
	if Touches.size() < 2:
		TouchesInfo["radius"] = 0
		TouchesInfo["previous_radius"] = 0
		return
	
	TouchesInfo["previous_radius"] = TouchesInfo["radius"]
	TouchesInfo["radius"] = (Touches.values()[0].current.position - TouchesInfo["target"]).length()
	
	if TouchesInfo["previous_radius"] == 0:
		return
	
	ZoomFactor = (TouchesInfo["previous_radius"] - TouchesInfo["radius"]) / TouchesInfo["previous_radius"]
	var finalZoom = zoom.x + ZoomFactor
	
	zoom = Vector2(finalZoom, finalZoom)
	zoom.x = clamp(zoom.x, ZoomMin, ZoomMax)
	zoom.y = clamp(zoom.y, ZoomMin, ZoomMax)
	
	var vpSize = self.get_viewport().size
	if get_viewport().is_size_override_enabled():
		vpSize = get_viewport().get_size_override()
	var oldDist = ((TouchesInfo["target"] - (vpSize / 2.0)) * (zoom - Vector2(ZoomFactor, ZoomFactor)))
	var newDist = ((TouchesInfo["target"] - (vpSize / 2.0)) * zoom)
	var camNeedMove = oldDist - newDist
	self.position += camNeedMove

func resetSmooth():
	lastCamPos = self.position
	curVel = Vector2(0, 0)

#implement new _process here
func _process(delta):
	if delta <=0:
		return
	
	if Touches.size() > 0:
		updateVel(delta)
		
	if Touches.size() == 0:
		doRealSmoothing(delta)
		
		var x : float = clamp(self.position.x, 0, Bounds.x)
		var y : float = clamp(self.position.y, 0, Bounds.y)
		self.position = Vector2(x,y)

func updateVel(delta : float):
	var cur_cam_pos := self.position
	var move := lastCamPos - cur_cam_pos
	var moveSpeed : Vector2 = move / delta
	curVel = (curVel + moveSpeed) / 2.0
	curVel.x = clamp(curVel.x, -10000, 10000)
	curVel.y = clamp(curVel.y, -10000, 10000)
	lastCamPos = self.position
	
func doRealSmoothing(delta : float):
	var l = curVel.length()
	var moveFrame = 10 * exp(panSmooth * ((log(l/10) / panSmooth) + delta))
	curVel = curVel.normalized() * moveFrame
	self.position -= curVel * delta

func smoothGoTo(target : Vector2, delta : float):
	var vec : Vector2 = target - self.position
	var l = vec.length()
	var moveFrame = 10 * exp(followSmooth * ((log(l/10) / followSmooth)+delta))
	var totalMove = vec.normalized() * moveFrame * delta
	if totalMove.length() > 1:
		totalMove = vec
	self.position += totalMove
	





