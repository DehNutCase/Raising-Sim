class_name Enemy extends Character

var portrait = "uid://dkkm2aamicapl" #res://Art/Portraits/mao_portrait.png

func _init(enemy = {}, node_name = "Enemy"):
	name = node_name
	if "stats" in enemy:	
		for stat in enemy.stats:
			base_stats[stat] = enemy.stats[stat]
	stats.current_hp = base_stats.max_hp
	
	display_stats = ["level", "experience", "gold",] + Constants.stats.base_stats
