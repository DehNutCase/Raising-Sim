class_name ExpeditionOption
extends MarginContainer

##The combat that's played when this node is selected
@export var combat:String
##The name of the timeline that's played when the scene is selected
@export var timeline:String
@onready var button:Button = %Button
signal option_selected

func _on_button_pressed():
	option_selected.emit(combat, timeline)
