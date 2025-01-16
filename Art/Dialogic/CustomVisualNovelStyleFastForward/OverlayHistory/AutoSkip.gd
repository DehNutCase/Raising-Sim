extends TextureButton

func _ready():
	Dialogic.Inputs.auto_skip.toggled.connect(_on_auto_skip_toggled)
	
func _pressed():
	_on_auto_skip_toggled(button_pressed)

func _on_auto_skip_toggled(toggle):
	Dialogic.Inputs.auto_skip._set_enabled(toggle)
	button_pressed = toggle
	return
