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
var active_status = {}

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
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)
	
	if health <= 0:
		return
	if active_status.get("Immune"):
		return
		
	if active_status.get("Vulnerable"):
		damage = int(damage * 3 / 2)
		
	var initial_damage = damage
	
	damage = clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	
	health -= damage

	if health <= 0:
		queue_free()
		get_tree().call_group("CardGameMainNode", "check_victory")

func set_intent() -> void:
	intent = actions.pick_random() as CardResource
	if intent.type == CardResource.Type.ATTACK or intent.type == CardResource.Type.BLOCK:
		%IntentLabel.text = str(intent.effect_amount)
	else:
		%IntentLabel.text = ""
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
	
func apply_status(status_resource: CardGameStatusResource, effect_amount: int, user) -> void:
	if active_status.get("Resistance") and status_resource.NegativeStatus:
		active_status["Resistance"].stacks -= 1
		active_status["Resistance"].status_display.stack_label.text = str(active_status["Resistance"].stacks)
		if active_status["Resistance"].stacks == 0:
			active_status["Resistance"].status_display.queue_free()
			active_status.erase("Resistance")
		return
		
	if status_resource.status_name in active_status:
		active_status[status_resource.status_name].stacks += effect_amount
		active_status[status_resource.status_name].status_display.stack_label.text = str(active_status[status_resource.status_name].stacks)
	else:
		var status_display:CardGameStatusDisplay = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status[status_resource.status_name] = {"stacks": effect_amount, "status": status_resource, "status_display": status_display}
		
		var status = active_status[status_resource.status_name].status
		%StatusBar.add_child(active_status[status_resource.status_name].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status[status_resource.status_name].stacks)
		status_display.tooltip_text = status.status_tooltip

func decay_status(timing: CardGameStatusResource.DecayType) -> void:
	for status_name in active_status:
		var status = active_status[status_name]
		if status.status.status_decay == timing:
			status.stacks -= 1
			status.status_display.stack_label.text = str(status.stacks)
			if status.stacks == 0:
				status.status_display.queue_free()
				active_status.erase(status_name)
	
	if timing == CardGameStatusResource.DecayType.ONE_TURN:
		for status_name in active_status:
			var status = active_status[status_name]
			if status.status.status_decay == timing:
				status.stacks = 0
				status.status_display.queue_free()
				active_status.erase(status_name)
			status.status_display.stack_label.text = str(status.stacks)
			
func do_turn() -> void:
	block = 0
	if active_status.get("Defense"):
		block = active_status.get("Defense").stacks
		if active_status.get("Magic"):
			block += active_status.get("Magic").stacks
	
	decay_status(CardGameStatusResource.DecayType.START_OF_TURN)
	await perform_intent()
	decay_status(CardGameStatusResource.DecayType.END_OF_TURN)
	decay_status(CardGameStatusResource.DecayType.ONE_TURN)
	
