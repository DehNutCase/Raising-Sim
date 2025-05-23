class_name CardGameStatusDisplay
extends HBoxContainer

@onready var status_texture:TextureRect = %StatusTexture
@onready var stack_label:Label = %StackLabel

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)
