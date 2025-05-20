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
	stats_bar.update_stats(stats) #only {health, block} matters
	mana_label.text = "%s/%s" % [mana, max_mana]

func take_damage(damage: int) -> void:
	modulate = Color(1,1,1,.5)
	await Player.shake(self, 50)
	modulate = Color(1,1,1,1)
	
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

func start_first_turn() -> void:
	start_turn()
	mana += int(Player.stats.speed/100)
	
	
func apply_immune(duration: int) -> void:
	pass
