extends Tabs


var levelsSpeed = []
var levelsSpeedRef = []
var levelsInput = []
var levelsInputRef = []
var levelsOutput = []
var levelsOutputRef = []

var current_speedLevel = 0
var current_InputLevel = 0
var current_OutputLevel = 0

var is_upgSpeed:bool = false
var is_upgInput:bool = false
var is_upgOutput:bool = false

var entityData

var timer_upgTime = 0.0 # Current timer

func configure(input_entityData):
	entityData = input_entityData
	match entityData["class"]:
		"speed":
			levelsSpeed.append(entityData["info"])
			levelsSpeedRef.append(entityData["reference"])
			pass
		"input":
			levelsInput.append(entityData["info"])
			levelsInputRef.append(entityData["reference"])
			pass
		"output":
			levelsOutput.append(entityData["info"])
			levelsOutputRef.append(entityData["reference"])
			pass
		_:
			print("incompatible upgData at: " + self.name)
			pass
	pass

func _process(delta):
	
	if is_upgSpeed == true:
		timer_upgTime += delta
		if timer_upgTime >= entityData["upgTime"]:
			timer_upgTime = 0
			is_upgSpeed = false
			current_speedLevel += 1
			var upgPath = MetaData.processorBank
			for index in levelsSpeedRef[current_speedLevel-1]:
				upgPath = upgPath[index]
			MetaData.processorBank[levelsSpeedRef[current_speedLevel-1][0]] [levelsSpeedRef[current_speedLevel-1][1]] [levelsSpeedRef[current_speedLevel-1][2]] [levelsSpeedRef[current_speedLevel-1][3]] = levelsSpeed[current_speedLevel-1]
			#upgPath = levelsSpeed[current_speedLevel-1]
			#print(MetaData.processorBank[entityData["reference"][0]][entityData["reference"][1]][entityData["reference"][2]])
			#upgPath = levelsSpeed[current_speedLevel-1]
			
			pass
		
		var progPerc = timer_upgTime/float(entityData["upgTime"])
		$ctnHBox/ctnVBoxSpeed/prgBar.value = stepify(100*progPerc,0.1)
	pass


func _on_btnSpeed_pressed():
	if is_upgInput == false and is_upgOutput == false:
		is_upgSpeed = true
	pass # Replace with function body.

