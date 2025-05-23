extends Control

@onready var hand = $UI/Hand
@onready var card_game_player: CardGamePlayer = %CardGamePlayer

var DRAW_INTERVAL = .1

enum states {NORMAL, VICTORY, DEFEAT, PLAYER_TURN, ENEMY_TURN}
var state = states.NORMAL

func _ready():
	for card:CardUI in hand.get_children():
		card.reparent_requested.connect(_on_card_ui_reparent_requested)
	start_battle()
	
func _on_card_ui_reparent_requested(card):
	card.reparent(hand)

func start_battle() -> void:
	card_game_player.draw_pile = card_game_player.deck.duplicate(true)
	card_game_player.draw_pile.cards.shuffle()
	card_game_player.discard = Deck.new()
	card_game_player.start_first_turn()
	start_turn()

func start_turn() -> void:
	card_game_player.start_turn()
	var draw_amount = card_game_player.cards_per_turn
	if Player.card_game_player.active_status.get("Wisdom"):
		draw_amount = draw_amount + Player.card_game_player.active_status.get("Wisdom").stacks
	if Player.card_game_player.active_status.get("Agility"):
		draw_amount = draw_amount + Player.card_game_player.active_status.get("Agility").stacks
	draw_cards(draw_amount)
	state = states.PLAYER_TURN

func end_turn() -> void:
	if state != states.PLAYER_TURN:
		return
	state = states.ENEMY_TURN
	get_tree().call_group("CardGameCardUI", "discard")
	for enemy: CardGameEnemy in get_tree().get_nodes_in_group("CardGameEnemies"):
		await enemy.do_turn()
	
	get_tree().call_group("CardGameEnemies", "set_intent")
	card_game_player.end_turn()
	start_turn()
	
func add_card(card: CardResource) -> void:
	#Quit if there's no card drawn
	if !card:
		return
	#Discard card if too many is drawn
	var effective_hand_size = card_game_player.max_hand_size
	if Player.card_game_player.active_status.get("Agility"):
		effective_hand_size = effective_hand_size + Player.card_game_player.active_status.get("Agility").stacks
	if Player.card_game_player.active_status.get("Scholarship"):
		effective_hand_size = effective_hand_size + Player.card_game_player.active_status.get("Scholarship").stacks
	
	if hand.get_child_count() >= effective_hand_size:
		card_game_player.discard.cards.append(card)
		return
	var new_card:CardUI = load("res://Scenes/CardGame/UI/card_ui.tscn").instantiate()
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
	var won = true
	
	for enemy:CardGameEnemy in get_tree().get_nodes_in_group("CardGameEnemies"):
		if enemy.health > 0:
			won = false
	
	if won:
		state = states.VICTORY
		#disable cards, refactor later?
		get_tree().call_group("CardGameCardUI", "enter_state", CardUI.States.VICTORY)
		print("we won!")
