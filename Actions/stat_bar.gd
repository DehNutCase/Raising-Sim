extends Node2D

@onready var stat_label = $StatLabel
@onready var stat_bar = $StatBar
var stat_name = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func display_stats():
	var tween = create_tween()
	tween.tween_property(stat_bar, "value", Player.stats[stat_name], .6)
	stat_label.text = Constants.stats[stat_name]["label"] + ": " + str(Player.stats[stat_name])
