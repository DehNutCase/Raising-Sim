extends Button

func _ready():
	#Update text if demo
	if OS.has_feature("demo"):
		text = "Start Demo"
