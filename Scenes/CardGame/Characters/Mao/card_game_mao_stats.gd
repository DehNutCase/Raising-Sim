class_name CardGameMaoStats
extends CardGameCharacterStats

@export var starting_deck: Deck
@export var cards_per_turn: int
@export var max_mana: int

var mana: int : set = set_mana
var deck: Deck
var discard: Deck
var draw_pile: Deck

func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func can_play_card(card: CardResource) -> bool:
	return mana >= card.cost

func reset_mana() -> void:
	mana = max_mana

func start_turn() -> void:
	reset_mana()
	block = int(Player.stats.defense/25)

func create_instance() -> CardGameCharacterStats:
	var instance: CardGameMaoStats = duplicate()
	instance.max_health = int(Player.stats.max_hp/5)
	instance.health = instance.max_health
	#Note, give mao block based on defense every turn
	instance.block = int(Player.stats.defense/25)
	instance.max_mana = int(Player.stats.max_mp/150 + 2)
	instance.cards_per_turn = int(Player.stats.scholarship/150 + 20)
	instance.reset_mana()
	instance.deck = starting_deck.duplicate()
	instance.draw_pile = Deck.new()
	instance.discard = Deck.new()
	
	return instance
