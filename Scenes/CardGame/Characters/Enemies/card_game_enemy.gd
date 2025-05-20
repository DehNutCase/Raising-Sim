class_name CardGameEnemy
extends Area2D

@export var stats: CardGameEnemyStats : set = set_enemy_stats

@onready var sprite: TextureRect = %Sprite
@onready var arrow: TextureRect = %Arrow
@onready var stat_bar: CardGameStatsBar = %StatsBar

var intent: CardResource

func _ready():
	set_intent()

func set_enemy_stats(value: CardGameEnemyStats) -> void:
	stats = value.create_instance()
	
	if !(stats.stats_changed.is_connected(update_stats)):
		stats.stats_changed.connect(update_stats)
	update_enemy()

func update_stats() -> void:
	stat_bar.update_stats(stats)

func update_enemy() -> void:
	if not stats is CardGameEnemyStats:
		printerr("is not CardGameEnemyStats")
		return
	if not is_inside_tree():
		await ready
	
	sprite.texture = stats.art
	update_stats()

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)
	
	if stats.health <= 0:
		queue_free()
		get_tree().call_group("CardGameMainNode", "check_victory")

func set_intent() -> void:
	intent = stats.actions.pick_random() as CardResource
	%IntentLabel.text = str(intent.effect_amount)
	%IntentTexture.texture = intent.icon
	if !intent:
		printerr("set_intent error")

func perform_intent() -> void:
	if intent.type == intent.Type.ATTACK:
		var tween := create_tween().set_trans(Tween.TRANS_QUINT)
		var start := global_position
		#Hard coded, figure out a way to fetch player position later?
		var end := Vector2(425, 400)
		
		tween.tween_property(self, "global_position", end, .4)
		tween.tween_interval(.1)
		tween.tween_property(self, "global_position", start, .4)
		await get_tree().create_timer(.3).timeout
	else:
		await Player.shake(self, 50)
		
	intent.enemy_play(self)
	await get_tree().create_timer(.4).timeout

func do_turn() -> void:
	await perform_intent()

func reset_block() -> void:
	stats.block = 0
