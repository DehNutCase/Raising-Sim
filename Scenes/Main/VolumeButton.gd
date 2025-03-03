extends TextureButton

func _update():
	button_pressed = AppSettings.is_muted()
