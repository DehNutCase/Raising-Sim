class_name CardUI
extends Control

#unsure use
signal reparent_requested(card: CardUI)

@onready var color = $ColorRect

enum States {BASE, DRAGGING, RELEASED}
@export var current_state:States
@export var initial_state:States

var targets = []
var played = false

@export var card: CardResource = load("res://Scenes/CardGame/Characters/Mao/Cards/mao_basic_attack.tres")

func _ready():
	pass
	
func enter_state(state:States) -> void:
	match state:
		States.BASE:
			reparent_requested.emit(self)
			$StateLabel.text = "BASE"
			pivot_offset = Vector2.ZERO
			current_state = States.BASE
		States.DRAGGING:
			reparent(get_tree().get_first_node_in_group("CardGameMainNode"))
			$StateLabel.text = "DRAGGING"
			current_state = States.DRAGGING
		States.RELEASED:
			$StateLabel.text = "RELEASED"
			current_state = States.RELEASED
			played = false
			if targets:
				if card.is_single_target():
					if targets.size() < 2:
						enter_state(States.BASE)
						return
				play_card()
	
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

func _on_area_area_entered(area: Area2D) -> void:
	if !(area in targets):
		targets.append(area)


func _on_area_area_exited(area: Area2D) -> void:
	targets.erase(area)
