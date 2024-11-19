class_name Enemy extends Character

#TODO, use portrait based on enemy race or class
var portrait = "uid://dkkm2aamicapl" #res://Art/Portraits/mao_portrait.png
var combat_skills = ["basic_attack"]
var label = "Enemy"

func _init(enemy: Variant, node_name = "Enemy"):
	name = node_name
	calculate_stats(enemy)
	
	display_stats = ["level", "experience", "gold",] + Constants.stats.base_stats

func calculate_stats(enemy) -> void:
	var enemy_stats = {}
	var enemy_skills = []
	
	if "race" in enemy:
		label = Constants.races[enemy.race].label
		var base_stats = {}
		if "base_stats" in Constants.races[enemy.race]:
			base_stats = Constants.races[enemy.race].base_stats
		for stat in base_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += base_stats[stat]
			else:
				enemy_stats[stat] = base_stats[stat]
		
		var level_stats = {}
		if "level_stats" in Constants.races[enemy.race]:
			level_stats = Constants.races[enemy.race].level_stats
		for stat in level_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += level_stats[stat] * enemy.level
			else:
				enemy_stats[stat] = level_stats[stat] * enemy.level
		
		if "combat_skills" in Constants.races[enemy.race]:
			for combat_skill in Constants.races[enemy.race].combat_skills:
				enemy_skills.append(combat_skill)

	if "character_class" in enemy:
		label += " " + Constants.character_classes[enemy.character_class].label
		var base_stats = {}
		if "base_stats" in Constants.character_classes[enemy.character_class]:
			base_stats = Constants.character_classes[enemy.character_class].base_stats
		for stat in base_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += base_stats[stat]
			else:
				enemy_stats[stat] = base_stats[stat]
				
		var level_stats = {}
		if "level_stats" in Constants.character_classes[enemy.character_class]:
			level_stats = Constants.character_classes[enemy.character_class].level_stats
		for stat in level_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += level_stats[stat] * enemy.level
			else:
				enemy_stats[stat] = level_stats[stat] * enemy.level
				
		if "combat_skills" in Constants.character_classes[enemy.character_class]:
			for combat_skill in Constants.character_classes[enemy.character_class].combat_skills:
				enemy_skills.append(combat_skill)
	
	for stat in enemy_stats:
		base_stats[stat] = enemy_stats[stat]
	stats.current_hp = base_stats.max_hp

	for combat_skill in enemy_skills:
		combat_skills.append(combat_skill)
		
	return
