extends Control

@onready var hand = %Hand
@onready var card_game_player: CardGamePlayer = %CardGamePlayer

var DRAW_INTERVAL = .05

enum states {VICTORY, DEFEAT, PLAYER_TURN, ENEMY_TURN}
var state = states.PLAYER_TURN

@export var card_game_level: PackedScene
var enemy_scene: CardGameEncounterScene

@onready var cubism_model: GDCubismUserModel = %CubismModel
@onready var cubism_container: PanelContainer = %CubismContainer

@onready var inventory_item_list: ItemList = %InventoryItemList
@onready var relic_item_list: ItemList = %RelicItemList

@onready var flee_button = %FleeButton

func _ready():
	Player.play_song("battle")
	if Player.encounter:
		card_game_level = load(Player.encounter)
	enemy_scene = card_game_level.instantiate()
	if enemy_scene:
		%EnemiesContainer.add_child(card_game_level.instantiate())
		if enemy_scene.background:
			%Background.texture = enemy_scene.background
		if enemy_scene.background_music:
			SoundManager.play_music(enemy_scene.background_music)
			
	if Player.inventory:
	#Takes from the inventory, i.e., items, here are potions, relics are elsewhere, implement later
		for item in Player.inventory._items:
			if item.get_property("combat_item", {}):
				card_game_player.combat_items.append(item.get_property("combat_item", {}))
		for item in card_game_player.combat_items:
			var item_info = Constants.combat_items[item]
			var index = inventory_item_list.add_item(item_info.label)
			inventory_item_list.set_item_metadata(index, {"name": item})
			inventory_item_list.set_item_tooltip(index, item_info.description)
			inventory_item_list.set_item_icon(index, load(item_info.icon))
		inventory_item_list.item_clicked.connect(_on_item_press)
			
		for item in Player.background_inventory._items:
			if item.get_property("relic", {}):
				card_game_player.relics.append(item.get_property("relic", {}))
		for item in card_game_player.relics:
			var item_info = Constants.relics[item]
			var index = relic_item_list.add_item(item_info.label)
			relic_item_list.set_item_metadata(index, {"name": item})
			relic_item_list.set_item_tooltip(index, item_info.description)
			relic_item_list.set_item_icon(index, load(item_info.icon))
		relic_item_list.item_clicked.connect(_on_relic_press)
		
	var buttons = get_tree().get_nodes_in_group("Button")
	for button in buttons:
		button.connect("pressed", _play_button_sound)
		
	start_battle()
	
func _on_card_ui_reparent_requested(card):
	card.reparent(hand)

func start_battle() -> void:
	card_game_player.draw_pile = Player.card_game_deck.duplicate(true)
	if OS.has_feature("debug") and not card_game_player.draw_pile:
		card_game_player.draw_pile = card_game_player.deck
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
	Player.play_ui_sound("draw_card")
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
			flee_button.custom_minimum_size = Vector2(240,70)
			hand.hide()
			flee_button.text = "Leave"

func check_defeat() -> void:
	if Player.card_game_player.health <= 0 and state != states.DEFEAT:
		state = states.DEFEAT
		flee_button.custom_minimum_size = Vector2(240,70)
		hand.hide()
		await get_tree().create_timer(1).timeout
		Player.play_random_voice("failure")
		
#Currently race condition due to damage being dealt to player and winning duel at the same time, hence the .5s timer
func win_duel() -> void:
	await get_tree().create_timer(.5).timeout
	await check_defeat()
	if state != states.DEFEAT:
		for enemy:CardGameEnemy in get_tree().get_nodes_in_group("CardGameEnemies"):
			enemy.health = 0
			enemy.queue_free()
		check_victory()
		
func exit_combat() -> void:
	Player.expedition_health = clampi(Player.card_game_player.health, 0 ,Player.card_game_player.health)
	if state == states.VICTORY:
		if Player.in_tower:
			Player.tower_level += 1
		if Player.in_mission:
			Player.active_mission.combat = false
		#TODO, in expedition flag here
		if Player.in_expedition:
			pass
		Player.reward_signal = enemy_scene.victory_reward
	Player.in_tower = false
	Player.in_mission = false
	Player.in_expedition = false
	get_tree().call_group("Main", "exit_card_game")
	queue_free()
	#TODO, modify for new card game scene
	#SceneLoader.load_scene("res://Scenes/Main/Main.tscn")

func play_live2d_animation(model: String, motion: String, duration: float) -> void:
	cubism_model.assets = model
	cubism_model.anim_motion = motion
	cubism_container.show()
	await get_tree().create_timer(duration).timeout
	cubism_container.hide()

func update_mana_labels():
	if hand:
		for card:CardUI in hand.get_children():
			card._update_mana_label()

#mouse position and button isn't used
func _on_item_press(index: int, mouse_position, mouse_button):
	if state == states.VICTORY:
		Player.display_toast("You're currently doing a victory dance and can't act!", "top")
		return
	if state ==  states.DEFEAT:
		Player.display_toast("You're unconsious and can't act!", "top")
		return
	if state != states.PLAYER_TURN:
		return
		
	var name = inventory_item_list.get_item_metadata(index).name.to_lower()

	var action = Constants.combat_items[name]
	var effect = action.effects
	
	if action.effects.get("health"):
		card_game_player.heal_damage(action.effects.health)
	if action.effects.get("mana"):
		card_game_player.mana += action.effects.mana
	if action.effects.get("buffs"):
		var buffs = action.effects.buffs
		for buff in buffs:
			var status = load(buff)
			card_game_player.apply_status(status, buffs[buff])
		
	var item = Player.inventory.get_item_with_prototype_id(name)
	Player.inventory.remove_item(item)
	#Remove item from list of items if we don't have it anymore
	if !Player.inventory.get_item_with_prototype_id(name):
		Player.combat_items.erase(name)
		inventory_item_list.remove_item(index)
		
	var message = action.message_player
	Player.display_toast(message)
	await get_tree().create_timer(Constants.constants.TOAST_TIMEOUT_DURATION).timeout

func _on_relic_press(index: int, mouse_position, mouse_button):
	if state == states.VICTORY:
		Player.display_toast("You're currently doing a victory dance and can't show off your relics!", "top")
		return
	if state ==  states.DEFEAT:
		Player.display_toast("You're unconsious and can't act!", "top")
		return
	if state != states.PLAYER_TURN:
		return
		
	var name = relic_item_list.get_item_metadata(index).name.to_lower()

	var relic = Constants.relics[name]
	var card: CardResource = load(relic.card)
	
	if card:
		if card_game_player.mana < card.cost:
			Player.display_toast("Not enough mana to use this.")
			await get_tree().create_timer(Constants.constants.TOAST_TIMEOUT_DURATION).timeout
		else:
			var message = relic.message_player
			Player.display_toast(message)
			#TODO, change targets depending on relic targets
			card_game_player.mana -= card.cost
			card.play([card_game_player])
			await get_tree().create_timer(Constants.constants.TOAST_TIMEOUT_DURATION).timeout
	else:
		var message = relic.message_player
		Player.display_toast(message)
		await get_tree().create_timer(Constants.constants.TOAST_TIMEOUT_DURATION).timeout
	
func _on_inventory_button_pressed():
	inventory_item_list.visible = !inventory_item_list.visible
	if inventory_item_list.visible:
		relic_item_list.hide()

func _on_relic_button_pressed():
	relic_item_list.visible = !relic_item_list.visible
	if relic_item_list.visible:
		inventory_item_list.hide()
	
func _play_button_sound() -> void:
	Player.play_ui_sound("blop")
