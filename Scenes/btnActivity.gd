extends TouchScreenButton

# Custom Variables
var resName = null
var resTime = null
var resCost = null
var resGain = null

# Basic Function Variables
var resAmount = 0
var clkTimer = 0
var isProcessing = false
var isDiscovered = false
var colWhite = Color(1,1,1,1)
var colBlack = Color(0,0,0,1)

# Node Property Variables
var nodeTouchScreenButton = null
var nodeProgressBar = null # Progress Bar
var nodeLabel = null # resAmount display text
var nodeAnimate_click = null # Green flash animation
var nodeAnimate_Nclick = null # Red flash animation
var nodeAnimate_Highlight = null
var nodeAnimate_Unavaliable = null

func checkResCost(resCostList,spendRes):
	var successCheck = true
	for resCostItem in resCostList:
		if get_node("../btn"+resCostItem[0]).resAmount < resCostItem[1]:
			successCheck = false
			if spendRes == true and isDiscovered:
				get_node("../btn"+resCostItem[0]).nodeAnimate_Highlight.seek(0) # Restart animation
				get_node("../btn"+resCostItem[0]).nodeAnimate_Highlight.play("aniTexture") # Highlight the required resource
	# If we've got to this point we have enough resources
	if spendRes == true and successCheck == true:
		for resCostItem in resCostList:
			get_node("../btn"+resCostItem[0]).resAmount -= resCostItem[1]
	return successCheck

func initialiseNodeRefs():
	nodeTouchScreenButton = self
	nodeProgressBar = get_node("TimerBar") # Progress Bar
	nodeLabel = get_node("ResLabel") # resAmount display text
	nodeAnimate_click = get_node("ClickAnimation") # Green flash animation
	nodeAnimate_Nclick = get_node("NClickAnimation") # Red flash animation
	nodeAnimate_Highlight = get_node("Highlight") # Highlight animation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Decrease Timer
	if isProcessing: # Are we still waiting for resource gain
		clkTimer += 1 # Move the timer forward
		if clkTimer >= resTime: # If the timer is up
			clkTimer = 0 			# Reset it
			isProcessing = false 	# stop processing
			resAmount += resGain 			# Gain a resource
		nodeProgressBar.value = int(100*clkTimer/resTime) # Update Progress Bar
	
	#Update Value
	nodeLabel.text = str(resAmount)
	
	# Check if a resource can be discovered
	if isDiscovered == false:
		if checkResCost(resCost,false) == false:
			self.self_modulate = colBlack
			nodeLabel.visible = false
		else:
			isDiscovered = true
			self.self_modulate = colWhite
			nodeLabel.visible = true

func _on_TouchScreenButton_released():
	if isProcessing == false and checkResCost(resCost,true) == true:
		isProcessing = true
		nodeAnimate_click.play("aniTexture") # Animate green flash
	else:
		nodeAnimate_Nclick.seek(0) # Restart animation
		nodeAnimate_Nclick.play("aniTexture") # Animate red flash
