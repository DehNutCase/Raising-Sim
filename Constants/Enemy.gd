class_name Enemy extends Character

var portrait = 'uid://dkkm2aamicapl' #res://Art/Portraits/mao_portrait.png

func _init(init_stats = {}):
	for stat in init_stats:
		base_stats[stat] = init_stats[stat]
	stats.current_hp = base_stats.max_hp
