class_name CustomPopup
extends MarginContainer


@onready var PopupLabel = %PopupLabel

signal button_clicked(value: bool)


func _input(event):
	if event.is_action_pressed("ui_cancel") and is_visible_in_tree():
		_on_no_button_pressed()
		get_viewport().set_input_as_handled()

func set_text(text:String):
	PopupLabel.clear()
	PopupLabel.append_text(text)

func _on_no_button_pressed():
	Player.play_ui_sound("cancel_blop")
	button_clicked.emit(false)
	hide()
	
func _on_yes_button_pressed():
	Player.play_ui_sound("blop")
	button_clicked.emit(true)
	hide()

