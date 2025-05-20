extends Node2D

@onready var hand = $UI/Hand
@onready var card_game_player: CardGamePlayer = %CardGamePlayer

var DRAW_INTERVAL = 0

enum states {NORMAL, VICTORY, DEFEAT, PLAYER_TURN, ENEMY_TURN}
var state = states.NORMAL

func _ready():
	for card:CardUI in hand.get_children():
		card.reparent_requested.connect(_on_card_ui_reparent_requested)
	
	start_battle()
	

func _process(delta):
	if state != states.VICTORY:
		check_victory()
	
	
func _on_card_ui_reparent_requested(card):
	card.reparent(hand)


func start_battle() -> void:
	card_game_player.draw_pile = card_game_player.deck.duplicate(true)
	card_game_player.draw_pile.cards.shuffle()
	card_game_player.discard = Deck.new()
	start_turn()

func start_turn() -> void:
	card_game_player.start_turn()
	draw_cards(card_game_player.cards_per_turn)

func end_turn() -> void:
	get_tree().call_group("CardGameCardUI", "discard")
	get_tree().call_group("CardGameEnemies", "reset_block")
	for enemy: CardGameEnemy in get_tree().get_nodes_in_group("CardGameEnemies"):
		await enemy.do_turn()
	
	get_tree().call_group("CardGameEnemies", "set_intent")
	start_turn()
	
func add_card(card: CardResource) -> void:
	#Quit if there's no card drawn
	if !card:
		return
	#Discard card if too many is drawn
	if hand.get_child_count() >= card_game_player.max_hand_size:
		card_game_player.discard.cards.append(card)
		return
	var new_card:CardUI = load("res://Scenes/CardGame/Card/card_ui.tscn").instantiate()
	new_card.card = card
	hand.add_child(new_card)
	new_card.reparent_requested.connect(_on_card_ui_reparent_requested)

func draw_card() -> void:
	if card_game_player.draw_pile.cards:
		add_card(card_game_player.draw_pile.draw_card())
	else:
		if card_game_player.discard.cards:
			card_game_player.draw_pile.cards = card_game_player.discard.cards
			card_game_player.draw_pile.cards.shuffle()
			card_game_player.discard.cards = []
			add_card(card_game_player.draw_pile.draw_card())
	
func draw_cards(amount: int) -> void:
	hand.add_theme_constant_override("separation", 10 - amount * 2)
	var tween: Tween = create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(DRAW_INTERVAL)
	await tween.finished
	
func check_victory() -> void:
	if !get_tree().get_nodes_in_group("CardGameEnemies"):
		state = states.VICTORY
		print("you won!")
