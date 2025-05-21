class_name CardGameEnemy
extends Area2D

@export var enemy_resource: CardGameEnemyStats

@onready var sprite: TextureRect = %Sprite
@onready var arrow: TextureRect = %Arrow
@onready var stats_bar: CardGameStatsBar = %StatsBar

var max_health: int = 10
var health: int = 10 : set = set_health
var block: int = 0 : set = set_block
var actions:Array[CardResource] = []

var intent: CardResource

func _ready():
	initialize_enemy_stats(enemy_resource)

func initialize_enemy_stats(value: CardGameEnemyStats) -> void:
	enemy_resource = value
	max_health = enemy_resource.max_health
	health = max_health
	block = 0
	sprite.texture = enemy_resource.art
	actions = enemy_resource.actions
	update_stats()
	set_intent()

func update_stats() -> void:
	var stats = {"health": health, "block": block, "max_health": max_health}
	stats_bar.update_stats(stats) #only {health, block} matters
	
func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	update_stats()
	
func set_block(value: int) -> void:
	block = clampi(value, 0, 999)
	update_stats()

func take_damage(damage: int) -> void:
	if health <= 0:
		return
	
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	
	health -= damage
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)

	if health <= 0:
		queue_free()
		get_tree().call_group("CardGameMainNode", "check_victory")
	
func set_intent() -> void:
	intent = actions.pick_random() as CardResource
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
	block = 0
