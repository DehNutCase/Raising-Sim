class_name CardGamePlayer
extends Node2D

@export var stats: CardGameMaoStats : set = set_character_stats

@onready var sprite = %CharacterTexture
@onready var stats_bar: CardGameStatsBar = %StatsBar
@onready var mana_label: Label = %ManaLabel

func set_character_stats(value: CardGameMaoStats) -> void:
	stats = value
	
	if !(stats.stats_changed.is_connected(update_stats)):
		stats.stats_changed.connect(update_stats)
	update_player()

func update_player() -> void:
	if not stats is CardGameMaoStats:
		return
	if not is_inside_tree():
		await ready
	
	sprite.texture = stats.art
	update_stats()

func update_stats() -> void:
	stats_bar.update_stats(stats)
	mana_label.text = "%s/%s" % [stats.mana, stats.max_mana]

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)
	stats.take_damage(damage)
	
	if stats.health <= 0:
		print("you lost!")
