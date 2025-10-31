extends Control

func _gui_input(event):
	if event is InputEventMouse and event.is_pressed():%PlayerHitArea.set_target(%PlayerSprite.to_local(get_global_mouse_position()))
