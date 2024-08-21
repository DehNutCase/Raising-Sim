class_name Enemy extends Character

var portrait = 'uid://dkkm2aamicapl' #res://Art/Portraits/mao_portrait.png

func _init():
	base_stats = {
		'max_hp': 100,
		'strength': 10,
		'defense': 5,
		'level': 1,
		'gold': 100,
	}
