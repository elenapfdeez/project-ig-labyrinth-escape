extends HBoxContainer

func _process(_delta):
	var corazones = get_children() #vida en total
	
	var vida_actual = GameManager.vida
	
	for i in range(corazones.size()):
		if i < vida_actual:
			corazones[i].visible = true
		else:
			corazones[i].visible = false
