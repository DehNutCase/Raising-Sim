extends MarginContainer

@onready var stat:String = self.name

@onready var label = $Background/Label
@onready var value = $Background/HBoxContainer/Value
@onready var emoji = $Background/HBoxContainer/Emoji
# Called when the node enters the scene tree for the first time.

func _ready():
	display_stats()
	pass # Replace with function body.

func display_stats():
	if stat == "mood":
		#TODO, adjust emoji based on mood
		label.text = "Mood"
		value.text = str(100 - Player.stats["stress"])
		emoji.text = '🫠'
	elif stat == "walks":
		label.text = "Walks"
		value.text = str(Player.remaining_walks)
		emoji.text = '👟'
	else:
		label.text = str(Constants.stats[stat]["label"])
		value.text = str(Player.stats[stat])
		
		if "emoji" in (Constants.stats[stat]):
			emoji.text = Constants.stats[stat].emoji
		else:
			emoji.text = ''
