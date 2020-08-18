extends Node2D

onready var localAreaNodes = [get_node("bodyOuter"),get_node("bodyDetect"),get_node("bodyInner")]
onready var sprResource = get_node("sprResource")

var toPosition = Vector2.ZERO
var speed = 0.5
var waiting = null
var stop = false
var resourceName = ""
var resourceType = "Solid"

func _process(_delta):
	
	if waiting == null:
		
		if stop == false:
			
			var direction = (toPosition - position).normalized()
			if (position - toPosition).length() < speed:
				position = toPosition
			else:
				position += direction*speed
			$bodyDetect.position = direction*9
			
	else:
		
		shapeActivity(waiting[0],waiting[1],waiting[2])

func shapeActivity(localAreaStr,remoteAreaNode,activityType):
	
	#print(localAreaStr,remoteAreaNode,activityType)
	#print(waiting," != ",[localAreaStr,remoteAreaNode,activityType])
	if waiting != null:
		if waiting != [localAreaStr,remoteAreaNode,activityType]:
			return # Prevent signals if they're not the waiting signal
	
	if remoteAreaNode in localAreaNodes: # Ignore activity with ourself
		return
	
	# If this is the center/tile area of an objFactoryTile
	if "Center" in remoteAreaNode.name or "Tile" in remoteAreaNode.name:
		
		#print(localAreaStr,remoteAreaNode,activityType)
		
		var objFactoryTile = remoteAreaNode.get_parent()
		
		# If the FactoryTile is empty
		if objFactoryTile.fatherNode == null:
			queue_free() # Delete ourself
			return # Stop
		
		var objFactoryEntity = objFactoryTile.fatherNode
		
		# If the FactoryTile belongs to a Structure
		if objFactoryEntity.entityType == "Structure":
			
			# If our bodyOuter has entered the structure
			if localAreaStr == "bodyOuter" and activityType == "Entered":
				
				if objFactoryEntity.inputResource(self) == true: # Let the structure node handle it
					queue_free()
					return
				else:
					waiting = [localAreaStr,remoteAreaNode,activityType]
		
		# If the FactoryTile belongs to a Connector
		elif objFactoryEntity.entityType == "Connector":
			
			# If the Connector is a Conveyor
			if objFactoryEntity.connectorType == "Conveyor":
				
				# If this is the center area of the conveyor
				if "Center" in remoteAreaNode.name:
					
					# If our bodyInner has entered the conveyor
					if localAreaStr == "bodyInner" and activityType == "Entered":
						
						if objFactoryEntity.pointResource(self) == true: # Let the conveyor node handle it
							waiting = null
						else:
							waiting = [localAreaStr,remoteAreaNode,activityType]
					
				# If this is the tile area of the conveyor
				elif "Tile" in remoteAreaNode.name:
					
					# If our bodyOuter has activity:
					if localAreaStr == "bodyOuter":
						
						# Update the conveyor's resourceList
						if activityType == "Entered":
							speed = objFactoryEntity.conveyorSpeed
							if objFactoryEntity.makeCurrent(self) == true:
								waiting = null
							else:
								waiting = [localAreaStr,remoteAreaNode,activityType]
						elif activityType == "Exited":
							objFactoryEntity.resetCurrent()
	
	# If this is the outer area of another objResourceNode
	elif "Outer" in remoteAreaNode.name:

		# If the activity occured on our detect area
		if localAreaStr == "bodyDetect":

			# If the resource entered our detect area
			if activityType == "Entered":
				stop = true
			elif activityType == "Exited":
				stop = false

# DETECT SHAPE for the leading circle
func _on_bodyDetect_area_entered(area):
	shapeActivity("bodyDetect",area,"Entered")
func _on_bodyDetect_area_exited(area):
	shapeActivity("bodyDetect",area,"Exited")

# DETECT SHAPE for the inner circle
func _on_bodyInner_area_entered(area):
	shapeActivity("bodyInner",area,"Entered")
func _on_bodyInner_area_exited(area):
	shapeActivity("bodyInner",area,"Exited")

# DETECT SHAPE for the outer circle
func _on_bodyOuter_area_entered(area):
	shapeActivity("bodyOuter",area,"Entered")
func _on_bodyOuter_area_exited(area):
	shapeActivity("bodyOuter",area,"Exited")
