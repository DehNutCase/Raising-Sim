extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display_day(day: int):
	day -= 1
	var days_in_month = Constants.constants.days_in_month
	var year: int = day / ( Constants.constants.months_in_year * days_in_month) + 1
	var seasons = Constants.constants.seasons
	var season: int = (day / days_in_month) % 4
	var date: int = day % days_in_month + 1
	#Don't display year for now
	#text = " Year: %s \n Season: %s \n Day: %s" % [year, seasons[season], date]
	text = " Season: %s \n Day: %s" % [seasons[season], date]
	Player.play_song(seasons[season])
