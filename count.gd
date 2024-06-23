extends MarginContainer

@onready var stat:String = self.name

@onready var label = $Background/Label
@onready var value = $Background/Value
# Called when the node enters the scene tree for the first time.

func _ready():
	display_stats(Player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_stats(character):
	label.text = str(Constants.stats[stat]['label'])
	value.text = str(character.stats[stat])
	pass
