extends Node2D

@export var char_stats: CharacterStats
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI
@onready var CardGamePlayer_handler: CardGamePlayerHandler = $CardGamePlayerHandler
@onready var enemy_handler: CardGameEnemyHandler = $CardGameEnemyHandler
@onready var CardGamePlayer: CardGamePlayer = $CardGamePlayer

@onready var Events = load("res://Scenes/CardGame/global/events.gd").new()

func _ready() -> void:
	# Normally, we would do this on a 'Run'
	# level so we keep our health, gold and deck
	# between battles.
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	CardGamePlayer.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.CardGamePlayer_turn_ended.connect(CardGamePlayer_handler.end_turn)
	Events.CardGamePlayer_hand_discarded.connect(enemy_handler.start_turn)
	Events.CardGamePlayer_died.connect(_on_CardGamePlayer_died)
	
	start_battle(new_stats)


func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicCardGamePlayer.play(music, true)
	enemy_handler.reset_enemy_actions()
	CardGamePlayer_handler.start_battle(stats)


func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)


func _on_enemy_turn_ended() -> void:
	CardGamePlayer_handler.start_turn()
	enemy_handler.reset_enemy_actions()


func _on_CardGamePlayer_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
