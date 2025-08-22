class_name TalentPointDisplay
extends Node2D

@onready var label = %Label
@onready var talent_point_texture = %TalentPointTexture

func _ready() -> void:
	update_label()
	
func update_label() -> void:
	label.text = str(Player.stats.talent_point)
