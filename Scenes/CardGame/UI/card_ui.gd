class_name CardUI
extends Control

signal reparent_requested(card: CardUI)

@onready var color = $ColorRect
@onready var panel = $Panel
@onready var icon = $Frame/Icon
@onready var cost_label = $Cost

enum States {BASE, DRAGGING, RELEASED, DISCARD, VICTORY}
@export var current_state:States
@export var initial_state:States

var targets: Array[Node] = []
var played = false

@export var card: CardResource : set = _set_card

@onready var card_text_label: RichTextLabel = %CardTextLabel

func _ready():
	pass
	
func enter_state(state:States) -> void:
	match state:
		States.BASE:
			reparent_requested.emit(self)
			pivot_offset = Vector2.ZERO
			current_state = States.BASE
		States.DRAGGING:
			reparent(get_tree().get_first_node_in_group("CardGameMainNode"))
			current_state = States.DRAGGING
		States.RELEASED:
			current_state = States.RELEASED
			played = false
			if targets:
				if card.is_single_target():
					if targets.size() < 2:
						enter_state(States.BASE)
						return
				play_card()
		States.DISCARD:
			current_state = States.DISCARD
		States.VICTORY:
			current_state = States.VICTORY
	
func exit_state(state:States) -> void:
	pass

func _gui_input(event):
	match current_state:
		States.BASE:
			if event.is_action_pressed("ui_click"):
				pivot_offset = get_global_mouse_position() - global_position
				change_state(States.BASE, States.DRAGGING)

func _input(event):
	match current_state:
		States.DRAGGING:
			if event is InputEventMouseMotion or InputEventJoypadMotion:
				global_position = get_global_mouse_position() - pivot_offset
			if event.is_action_pressed("ui_accept") or event.is_action("ui_click"):
				change_state(States.DRAGGING, States.RELEASED)
				get_viewport().set_input_as_handled()
			if event.is_action_pressed("ui_cancel"):
				change_state(States.DRAGGING, States.BASE)
				get_viewport().set_input_as_handled()
		States.RELEASED:
			if played:
				return
			change_state(States.RELEASED, States.BASE)

func change_state(from:States, to:States):
	if from != current_state:
		return
	exit_state(from)
	enter_state(to)

func play_card():
	played = true
	if targets and targets[-1] is CardGameEnemy:
		targets[-1].arrow.hide()
	if Player.card_game_player.mana >= card.cost:
		Player.card_game_player.mana -= card.cost
		card.play(targets)
		discard()
	else:
		played = false
		enter_state(States.BASE)

func _on_area_area_entered(area: Area2D) -> void:
	if !(area in targets):
		if card.is_single_target() and area is CardGameEnemy:
			area.arrow.show()
			if targets and targets[-1] is CardGameEnemy:
				targets[-1].arrow.hide()
		targets.append(area)

func _on_area_area_exited(area: Area2D) -> void:
	targets.erase(area)
	if area is CardGameEnemy:
		area.arrow.hide()
	if card.is_single_target() and targets and targets[-1] is CardGameEnemy:
		targets[-1].arrow.show()

func _set_card(value: CardResource) -> void:
	if not is_node_ready():
		await ready
	card = value
	cost_label.text = str(card.cost)
	icon.texture = card.icon
	
	%CardNameLabel.parse_bbcode("[center]" + card.id + "[/center]")
	tooltip_text = _create_tooltip()
	card_text_label.parse_bbcode("[center]" + _create_tooltip() + "[/center]")
	
func _create_tooltip() -> String:
	var tooltip = ""
	match card.type:
		card.Type.ATTACK:
			match card.target:
				card.Target.SELF:
					tooltip += "Deal [color=red]%d[/color] damage to yourself." %card.effect_amount
				card.Target.SINGLE_ENEMY:
					tooltip += "Deal [color=red]%d[/color] damage." %card.effect_amount
				card.Target.ALL_ENEMIES:
					tooltip += "Deal [color=red]%d[/color] damage to all enemies." %card.effect_amount
				card.Target.EVERYONE:
					tooltip += "Deal [color=red]%d[/color] damage to everyone." %card.effect_amount
		card.Type.BLOCK:
			match card.target:
				card.Target.SELF:
					tooltip += "Gain [color=blue]%d[/color] block." %card.effect_amount
				card.Target.SINGLE_ENEMY:
					tooltip += "Target enemy gains [color=blue]%d[/color] block." %card.effect_amount
				card.Target.ALL_ENEMIES:
					tooltip += "All enemies gain [color=blue]%d[/color] block." %card.effect_amount
				card.Target.EVERYONE:
					tooltip += "Everyone gains [color=blue]%d[/color] block." %card.effect_amount
		card.Type.STATUS:
			match card.target:
				card.Target.SELF:
					tooltip += "Gain [color=green]%d[/color] stack of %s." %[card.effect_amount, card.status.status_name]
				card.Target.SINGLE_ENEMY:
					tooltip += "Target enemy gains [color=green]%d[/color] stack of %s." %[card.effect_amount, card.status.status_name]
				card.Target.ALL_ENEMIES:
					tooltip += "All enemies gain [color=green]%d[/color] stack of %s." %[card.effect_amount, card.status.status_name]
				card.Target.EVERYONE:
					tooltip += "Everyone gains [color=green]%d[/color] stack of %s." %[card.effect_amount, card.status.status_name]
	
	#Copy above code for 2nd effect onwards
	if card.second_type != card.SecondType.NONE:
		tooltip += "\n"
		match card.second_type:
			card.SecondType.ATTACK:
				match card.second_target:
					card.Target.SELF:
						tooltip += "Deal [color=red]%d[/color] damage to yourself." %card.second_effect_amount
					card.Target.SINGLE_ENEMY:
						tooltip += "Deal [color=red]%d[/color] damage." %card.second_effect_amount
					card.Target.ALL_ENEMIES:
						tooltip += "Deal [color=red]%d[/color] damage to all enemies." %card.second_effect_amount
					card.Target.EVERYONE:
						tooltip += "Deal [color=red]%d[/color] damage to everyone." %card.second_effect_amount
			card.SecondType.BLOCK:
				match card.second_target:
					card.Target.SELF:
						tooltip += "Gain [color=blue]%d[/color] block." %card.second_effect_amount
					card.Target.SINGLE_ENEMY:
						tooltip += "Target enemy gains [color=blue]%d[/color] block." %card.second_effect_amount
					card.Target.ALL_ENEMIES:
						tooltip += "All enemies gain [color=blue]%d[/color] block." %card.second_effect_amount
					card.Target.EVERYONE:
						tooltip += "Everyone gains [color=blue]%d[/color] block." %card.second_effect_amount
			card.SecondType.STATUS:
				match card.second_target:
					card.Target.SELF:
						tooltip += "Gain [color=green]%d[/color] stack of %s." %[card.second_effect_amount, card.status.status_name]
					card.Target.SINGLE_ENEMY:
						tooltip += "Target enemy gains [color=green]%d[/color] stack of %s." %[card.second_effect_amount, card.status.status_name]
					card.Target.ALL_ENEMIES:
						tooltip += "All enemies gain [color=green]%d[/color] stack of %s." %[card.second_effect_amount, card.status.status_name]
					card.Target.EVERYONE:
						tooltip += "Everyone gains [color=green]%d[/color] stack of %s." %[card.second_effect_amount, card.status.status_name]
	return tooltip

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)

func discard() -> void:
	Player.card_game_player.discard.cards.append(card)
	enter_state(States.DISCARD)
	queue_free()
