extends MarginContainer

@onready var icon_1 = $VBoxContainer/HBoxContainer/MarginContainer/IconBackground/MarginContainer/TextureRect
@onready var icon_2 = $VBoxContainer/HBoxContainer/MarginContainer2/IconBackground/MarginContainer/TextureRect
@onready var icon_3 = $VBoxContainer/HBoxContainer/MarginContainer3/IconBackground/MarginContainer/TextureRect
@onready var icons = [icon_1, icon_2, icon_3]
var success_icons = [
	load("res://Characters/Mao/Images/Portrait/exp_01_000.png"),
	load("res://Characters/Mao/Images/Portrait/exp_02_000.png"),
	load("res://Characters/Mao/Images/Portrait/exp_04_000.png"),
	]
var failure_icons = [
	load("res://Characters/Mao/Images/Portrait/exp_05_000.png"),
	load("res://Characters/Mao/Images/Portrait/exp_07_000.png"),
	load("res://Characters/Mao/Images/Portrait/exp_08_000.png"),
	]


func _ready():
	update_icon(true, 0)
	update_icon(false, 1)
	update_icon(true, 2)

func update_icon(success = true, i = 0):
	if success:
		icons[i].texture = success_icons.pick_random()
	else:
		icons[i].texture = failure_icons.pick_random()
