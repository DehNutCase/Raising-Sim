extends MarginContainer

@onready var stat:String = self.name

@onready var label = %Label
@onready var value = %Value
@onready var emoji = %Emoji
@onready var texture = %Icon
@onready var texture_margin = %IconMargin
@onready var progress_bar = $Background/TextureProgressBar
# Called when the node enters the scene tree for the first time.

func _ready():
	display_stats()
	pass # Replace with function body.

func display_stats():
	texture_margin.hide()
	emoji.show()
	if stat == "mood":
		label.text = "Mood"
		value.text = str(100 - Player.stats["stress"])
		if Player.stats["stress"] < 50:
			emoji.text = '🫠'
		else:
			emoji.text = '😣'
		#Mood isn't a real stat so manually entered progress bar values here
		progress_bar.max_value = 100
		progress_bar.value = 100 - Player.stats["stress"]
	elif stat == "walks":
		label.text = "Walks"
		value.text = str(Player.remaining_walks)
		emoji.text = ""#'👟'
		texture.texture = load("res://Art/UI/mandinhart/More Icons/Icons/Map.png")
		texture_margin.show()
		emoji.hide()
		progress_bar.hide()
	else:
		label.text = str(Constants.stats[stat]["label"])
		value.text = str(Player.stats[stat])
		progress_bar.show()
		if stat == "gold":
			progress_bar.hide()
		progress_bar.value = Player.stats[stat]
		if Constants.stats[stat]:
			if Constants.stats[stat].get('max'):
				progress_bar.max_value = Player.calculate_max_stat(stat)
		if "emoji" in (Constants.stats[stat]):
			emoji.text = Constants.stats[stat].emoji
		else:
			emoji.text = ''
