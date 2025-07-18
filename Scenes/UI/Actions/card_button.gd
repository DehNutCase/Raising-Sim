class_name CardButton
extends MarginContainer

@onready var card_ui:CardUI = %CardUI

func _on_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("Main", "_on_card_button_pressed", card_ui.card)

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)
