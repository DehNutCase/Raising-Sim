class_name CardGamePlayer
extends Node2D

var max_health: int = 10
var health: int = 10 : set = set_health
var block: int = 0 : set = set_block
var max_mana: int = 2
var mana: int : set = set_mana
var cards_per_turn: int = 2
var max_hand_size: int = 2
@export var deck: Deck
var draw_pile: Deck = Deck.new()
var discard: Deck = Deck.new()

var art = load("res://Characters/Mao/Images/Portrait/exp_01_000.png")

#{"type":String, "stacks":int, "icon":texture}
var active_status = {}

@onready var sprite = %CharacterTexture
@onready var stats_bar: CardGameStatsBar = %StatsBar
@onready var mana_label: Label = %ManaLabel

func _ready():
	initialize_stats()
	
func initialize_stats() -> void:
	max_health = int(Player.stats.max_hp/5)
	#debug code
	if OS.has_feature("debug"):
		max_health = 5000
	health = max_health
	#Note, give mao block based on defense every turn
	max_mana = int(Player.stats.max_mp/150 + 2)
	mana = max_mana
	draw_pile = Deck.new()
	discard = Deck.new()
	
	#if Player.card_game_deck:
		#deck = Player.card_game_deck #card_game_deck is Array[CardResource]
	Player.card_game_player = self
	update_player()

func update_player() -> void:
	sprite.texture = art
	update_stats()

func update_stats() -> void:
	var stats = {"health": health, "block": block, "max_health": max_health}
	stats_bar.update_stats(stats)
	mana_label.text = "%s/%s" % [mana, max_mana]

func take_damage(damage: int) -> void:
	if active_status.get("Defense"):
		damage -= active_status.get("Defense").stacks
		
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)
	
	#adjust dmg here
	if active_status.get("Immune"):
		return
	if damage <= 0:
		return
		
	if active_status.get("Vulnerable"):
		damage = int(damage * 3 / 2)
		
	var initial_damage = damage
	
	damage = clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	health -= damage
	
	if health <= 0:
		get_tree().call_group("CardGameMainNode", "check_defeat")
		
func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	update_stats()
	
func set_block(value: int) -> void:
	block = clampi(value, 0, 999)
	update_stats()
	
func set_mana(value: int) -> void:
	mana = value
	update_stats()
	
func start_turn() -> void:
	mana = max_mana
	decay_status(CardGameStatusResource.DecayType.START_OF_TURN)
	if active_status.get("Burn"):
		var status = active_status.get("Burn")
		take_damage(status.stacks)
		status.stacks = int(status.stacks/2)
		if status.stacks == 0:
			status.status_display.queue_free()
			active_status.erase("Burn")
	block = 0

func end_turn() -> void:
	decay_status(CardGameStatusResource.DecayType.END_OF_TURN)
	decay_status(CardGameStatusResource.DecayType.ONE_TURN)

func start_first_turn() -> void:
	active_status = {}
	var status_display:CardGameStatusDisplay
	var children = %StatusBar.get_children()
	for child in children:
		child.queue_free()
		
	if Player.stats.attack / 150:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Attack"] = {"stacks": int(Player.stats.attack / 150), "status": load("res://Scenes/CardGame/Status/attack.tres"), "status_display": status_display}
		var status = active_status["Attack"].status
		%StatusBar.add_child(active_status["Attack"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Attack"].stacks)
		status_display.tooltip_text = status.status_tooltip
		
	if Player.stats.defense / 150:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Defense"] = {"stacks": int(Player.stats.defense / 150), "status": load("res://Scenes/CardGame/Status/defense.tres"), "status_display": status_display}
		var status = active_status["Defense"].status
		%StatusBar.add_child(active_status["Defense"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Defense"].stacks)
		status_display.tooltip_text = status.status_tooltip
	
	if Player.stats.scholarship / 150:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Scholarship"] = {"stacks": int(Player.stats.scholarship / 150), "status": load("res://Scenes/CardGame/Status/scholarship.tres"), "status_display": status_display}
		var status = active_status["Scholarship"].status
		%StatusBar.add_child(active_status["Scholarship"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Scholarship"].stacks)
		status_display.tooltip_text = status.status_tooltip
		
	if Player.stats.skill / 150:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Skill"] = {"stacks": int(Player.stats.skill / 150), "status": load("res://Scenes/CardGame/Status/skill.tres"), "status_display": status_display}
		var status = active_status["Skill"].status
		%StatusBar.add_child(active_status["Skill"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Skill"].stacks)
		status_display.tooltip_text = status.status_tooltip

		
	if Player.stats.magic / 150:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Magic"] = {"stacks": int(Player.stats.magic / 150), "status": load("res://Scenes/CardGame/Status/magic.tres"), "status_display": status_display}
		var status = active_status["Magic"].status
		%StatusBar.add_child(active_status["Magic"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Magic"].stacks)
		status_display.tooltip_text = status.status_tooltip

		
	if Player.stats.resistance / 150:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Resistance"] = {"stacks": int(Player.stats.resistance / 150), "status": load("res://Scenes/CardGame/Status/resistance.tres"), "status_display": status_display}
		var status = active_status["Resistance"].status
		%StatusBar.add_child(active_status["Resistance"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Resistance"].stacks)
		status_display.tooltip_text = status.status_tooltip
		
	if Player.stats.agility / 100:
		status_display = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status["Agility"] = {"stacks": int(Player.stats.agility / 150), "status": load("res://Scenes/CardGame/Status/agility.tres"), "status_display": status_display}
		var status = active_status["Agility"].status
		%StatusBar.add_child(active_status["Agility"].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status["Agility"].stacks)
		status_display.tooltip_text = status.status_tooltip
		
func apply_status(status_resource: CardGameStatusResource, effect_amount: int, user) -> void:
	if active_status.get("Resistance") and (status_resource.NegativeStatus or effect_amount < 0):
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
