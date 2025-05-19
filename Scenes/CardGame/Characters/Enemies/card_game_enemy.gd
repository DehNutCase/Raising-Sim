class_name CardGameEnemy
extends Area2D

@export var stats: CardGameCharacterStats : set = set_enemy_stats

@onready var sprite: TextureRect = %Sprite
@onready var arrow: TextureRect = %Arrow
@onready var stat_bar: CardGameStatsBar = %StatsBar

func set_enemy_stats(value: CardGameCharacterStats) -> void:
	stats = value.create_instance()
	
	if !(stats.stats_changed.is_connected(update_stats)):
		stats.stats_changed.connect(update_stats)
	update_enemy()

func update_stats() -> void:
	stat_bar.update_stats(stats)

func update_enemy() -> void:
	if not stats is CardGameCharacterStats:
		print("is not")
		return
	if not is_inside_tree():
		await ready
	
	sprite.texture = stats.art
	update_stats()

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		queue_free()
