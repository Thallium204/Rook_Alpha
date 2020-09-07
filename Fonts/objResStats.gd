extends HBoxContainer

func configure(resAmount, resName):
	$Label.text = str(resAmount)
	$TextureRect.texture = load("res://Assets/Resources/img_" + resName + ".png")
	pass
