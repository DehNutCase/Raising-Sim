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
	health = max_health
	#Note, give mao block based on defense every turn
	block = int(Player.stats.defense/25)
	max_mana = int(Player.stats.max_mp/150 + 2)
	mana = max_mana
	cards_per_turn = int(Player.stats.skill/150 + 2)
	max_hand_size = int(Player.stats.scholarship/150 + 2)
	draw_pile = Deck.new()
	discard = Deck.new()
	
	#Keep hp between combats
	if Player.card_game_health:
		health = Player.card_game_health
	#if Player.card_game_deck:
		#deck = Player.card_game_deck #card_game_deck is Array[CardResource]
	if Player.card_game_player:
		Player.card_game_player.queue_free()
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
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)
	
	#adjust dmg here
	if active_status.get("Immune"):
		return
	if damage <= 0:
		return
	
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	health -= damage
	
	if health <= 0:
		print("you lost!")
		
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
	block = int(Player.stats.defense/25)
	decay_status(CardGameStatusResource.DecayType.START_OF_TURN)

func end_turn() -> void:
	decay_status(CardGameStatusResource.DecayType.END_OF_TURN)

func start_first_turn() -> void:
	start_turn()
	mana += int(Player.stats.speed/100)
	
	
func apply_status(card: CardResource) -> void:
	if card.status.status_name in active_status:
		active_status[card.status.status_name].stacks += card.effect_amount
		active_status[card.status.status_name].status_display.stack_label.text = str(active_status[card.status.status_name].stacks)
	else:
		var status_display:CardGameStatusDisplay = load("res://Scenes/CardGame/UI/card_game_status_display.tscn").instantiate()
		active_status[card.status.status_name] = {"stacks": card.effect_amount, "status": card.status, "status_display": status_display}
		
		var status = active_status[card.status.status_name].status
		%StatusBar.add_child(active_status[card.status.status_name].status_display)
		status_display.status_texture.texture = status.status_icon
		status_display.stack_label.text = str(active_status[card.status.status_name].stacks)

func decay_status(timing: CardGameStatusResource.DecayType) -> void:
	for status_name in active_status:
		var status = active_status[status_name]
		if status.status.status_decay == timing:
			status.stacks -= 1
			if status.stacks == 0:
				status.status_display.queue_free()
				active_status.erase(status_name)
			status.status_display.stack_label.text = str(status.stacks)
