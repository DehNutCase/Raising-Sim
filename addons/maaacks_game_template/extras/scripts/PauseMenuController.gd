class_name PauseMenuController
extends Node
## Node for opening a pause menu when detecting a 'ui_cancel' event.

@export var pause_menu_packed : PackedScene

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		InGameMenuController.open_menu(pause_menu_packed, get_viewport())
		get_viewport().set_input_as_handled()

func _ready():
	InGameMenuController.scene_tree = get_tree()
