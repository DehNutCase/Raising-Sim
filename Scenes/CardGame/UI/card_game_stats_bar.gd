class_name CardGameStatsBar
extends HBoxContainer

@onready var block_label: Label = %BlockLabel
@onready var health_label: Label = %HealthLabel
@onready var block_hbox: HBoxContainer = %Block
@onready var health_hbox: HBoxContainer = %Health

func update_stats(stats) -> void:
	block_label.text = str(stats.block)
	health_label.text = str(stats.health)
	if stats.get("max_health"):
		health_label.text = "%s/%s" % [stats.health, stats.max_health]
	
	block_hbox.visible = stats.block > 0
	health_hbox.visible = stats.health > 0
