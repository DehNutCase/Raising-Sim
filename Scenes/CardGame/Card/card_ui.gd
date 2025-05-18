class_name CardUI
extends Control

#unsure use
signal reparent_requested(card: CardUI)

@onready var color = $ColorRect

enum STATES {BASE, DRAGGING, AIMING, RELEASED}
@export var current_state:STATES
@export var initial_state:STATES

func enter_state(state:STATES) -> void:
	print("entering ", state)
	match state:
		STATES.BASE:
			reparent_requested.emit(self)
			$StateLabel.text = "BASE"
			pivot_offset = Vector2.ZERO
			current_state = STATES.BASE
		STATES.DRAGGING:
			reparent_requested.emit(self)
			$StateLabel.text = "DRAGGING"
			current_state = STATES.DRAGGING
		STATES.RELEASED:
			$StateLabel.text = "RELEASED"
			current_state = STATES.RELEASED
	
func exit_state(state:STATES) -> void:
	current_state = state
	pass

func _gui_input(event):
	match current_state:
		STATES.BASE:
			if event.is_action_pressed("ui_click"):
				pivot_offset = get_global_mouse_position() - global_position
				change_state(STATES.BASE, STATES.DRAGGING)

func _input(event):
	match current_state:
		STATES.DRAGGING:
			if event is InputEventMouseMotion or InputEventJoypadMotion:
				global_position = get_global_mouse_position() - pivot_offset
			if event.is_action_pressed("ui_accept") or event.is_action("ui_click"):
				change_state(STATES.DRAGGING, STATES.RELEASED)
			if event.is_action_pressed("ui_cancel"):
				change_state(STATES.DRAGGING, STATES.BASE)

func change_state(from:STATES, to:STATES):
	if from != current_state:
		print("not current state")
		return
	
	exit_state(from)
	enter_state(to)

