extends Control

var resName = ""
var resTexture = null
var resTotal = 0

func updateUI():
	$conTab/labCurrent.text = str(resTotal)
	$conTab/texResource.texture = resTexture
