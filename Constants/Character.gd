class_name Character extends Node

var base_stats = {
	"max_hp": 12,
	"strength": 8,
	"magic": 9,
	"level": 1,
	"gold": 100,
}

@export var stats = {}
var display_stats = ["level", "experience", "gold", "stress"] + Constants.stats.base_stats + ["scholarship"]

signal experience_gained(growth_data)

@export var experience = 0
@export var experience_total = 0
@export var experience_required = 100

func get_required_experience(l) -> int:
	return int(pow(1.1, l) * 100)

func gain_experience(amount: int) -> void:
	if ("bonus_exp" in stats):
		amount = amount * (1 + stats.bonus_exp/100.0)
		amount = int(amount)
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required,experience_required])
		level_up()
	
	stats.experience = experience
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)
		
func level_up() -> void:
	stats["level"] += 1
	experience_required = get_required_experience(stats["level"] - 1)
	var stats = Constants.stats.base_stats
	for stat in stats:
		self.stats[stat] += 1
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for stat in display_stats:
		if !(stat in base_stats):
			stats[stat] = 0
		else:
			stats[stat] = base_stats[stat]
	for stat in base_stats:
		if !(stat in stats):
			stats[stat] = base_stats[stat]
