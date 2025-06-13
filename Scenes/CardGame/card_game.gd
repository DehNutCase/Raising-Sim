extends Control

@onready var hand = $UI/Hand
@onready var card_game_player: CardGamePlayer = %CardGamePlayer

var DRAW_INTERVAL = .05

enum states {VICTORY, DEFEAT, PLAYER_TURN, ENEMY_TURN}
var state = states.PLAYER_TURN

@export var card_game_level: PackedScene
var enemy_scene: CardGameEncounterScene

@onready var cubism_model: GDCubismUserModel = %CubismModel
@onready var cubism_container: PanelContainer = %CubismContainer

func _ready():
	Player.play_song("battle")
	if Player.encounter:
		card_game_level = load(Player.encounter)
	enemy_scene = card_game_level.instantiate()
	if enemy_scene:
		%EnemiesContainer.add_child(card_game_level.instantiate())
		if enemy_scene.background:
			%Background.texture = enemy_scene.background
	start_battle()
	
func _on_card_ui_reparent_requested(card):
	card.reparent(hand)

func start_battle() -> void:
	card_game_player.draw_pile = Player.card_game_deck.duplicate(true)
	#card_game_player.draw_pile = card_game_player.deck
	card_game_player.draw_pile.shuffle()
	card_game_player.discard = []
	card_game_player.start_first_turn()
	state = states.PLAYER_TURN
	start_turn()

func start_turn() -> void:
	card_game_player.start_turn()
	var draw_amount = card_game_player.cards_per_turn
	if Player.card_game_player.active_status.get("Skill"):
		draw_amount = draw_amount + Player.card_game_player.active_status.get("Skill").stacks
	if Player.card_game_player.active_status.get("Agility"):
		draw_amount = draw_amount + Player.card_game_player.active_status.get("Agility").stacks
	await draw_cards(draw_amount)
	if state == states.ENEMY_TURN:
		state = states.PLAYER_TURN

func end_turn() -> void:
	if state != states.PLAYER_TURN:
		return
	
	card_game_player.end_turn()
	
	state = states.ENEMY_TURN
	get_tree().call_group("CardGameCardUI", "discard")
	for enemy: CardGameEnemy in get_tree().get_nodes_in_group("CardGameEnemies"):
		await enemy.do_turn()
	get_tree().call_group("CardGameEnemies", "set_intent")

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
		card_game_player.discard.append(card)
		return
	var new_card:CardUI = load("res://Scenes/CardGame/UI/card_ui.tscn").instantiate()
	new_card.card = card
	hand.add_child(new_card)
	new_card.reparent_requested.connect(_on_card_ui_reparent_requested)

func draw_card() -> void:
	if card_game_player.draw_pile:
		add_card(card_game_player.draw_pile.pop_back())
		await get_tree().create_timer(DRAW_INTERVAL).timeout
	else:
		if card_game_player.discard:
			card_game_player.draw_pile = card_game_player.discard
			card_game_player.draw_pile.shuffle()
			card_game_player.discard = []
			add_card(card_game_player.draw_pile.pop_back())
			await get_tree().create_timer(DRAW_INTERVAL).timeout
	
func draw_cards(amount: int) -> void:
	for i in range(amount):
		await draw_card()
	hand.add_theme_constant_override("separation", clampi(20 - hand.get_child_count() * 4, -30, 20))
	
func check_victory() -> void:
	var won = true
	
	for enemy:CardGameEnemy in get_tree().get_nodes_in_group("CardGameEnemies"):
		if enemy.health > 0:
			won = false
	
	if won:
		if state != states.DEFEAT and Player.card_game_player.health >= 0:
			state = states.VICTORY
			hand.hide()
			%FleeButton.text = "Leave"

func check_defeat() -> void:
	if Player.card_game_player.health <= 0:
		state = states.DEFEAT
		hand.hide()
		
func exit_combat() -> void:
	if state == states.VICTORY:
		if Player.in_tower:
			Player.tower_level += 1
		if Player.in_mission:
			Player.active_mission.combat = false
		Player.reward_signal = enemy_scene.victory_reward
	Player.in_tower = false
	Player.in_mission = false
	SceneLoader.load_scene("res://Scenes/Main/Main.tscn")

func play_live2d_animation(model: String, motion: String, duration: float) -> void:
	cubism_model.assets = model
	cubism_model.anim_motion = motion
	cubism_container.show()
	await get_tree().create_timer(duration).timeout
	cubism_container.hide()
