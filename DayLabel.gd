extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_day(day: int):
	day -= 1
	var year: int = day / (4 * 28) + 1
	var seasons = ['Spring', 'Summer', 'Autumn', 'Winter']
	var season: int = (day / 28) % 4
	var date: int = day % 28 + 1
	text = " Year: %s \n Season: %s \n Day: %s" % [year, seasons[season], date]
