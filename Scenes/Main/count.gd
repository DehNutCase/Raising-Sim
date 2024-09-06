extends MarginContainer

@onready var stat:String = self.name

@onready var label = $Background/Label
@onready var value = $Background/Value
# Called when the node enters the scene tree for the first time.

func _ready():
	display_stats()
	pass # Replace with function body.

func display_stats():
	label.text = str(Constants.stats[stat]["label"])
	value.text = str(Player.stats[stat])
	pass
