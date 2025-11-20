extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display_day(day: int):
	day -= 1
	var days_in_month = Constants.constants.days_in_month
	var year: int = day / ( Constants.constants.months_in_year * days_in_month) + 1
	var month:int = ((day / (days_in_month)) % Constants.constants.months_in_year) + 1
	var seasons = Constants.constants.seasons
	var season: int = (month / (Constants.constants.months_in_year / seasons.size())) % (Constants.constants.months_in_year / seasons.size())
	var date: int = day % days_in_month + 1
	#Don't display year for now
	#text = " Year: %s \n Season: %s \n Day: %s" % [year, seasons[season], date]
	text = " Season: %s \n Month: %d \n Week: %s / %d" % [seasons[season], month, date, days_in_month]
	if OS.has_feature("demo"):
		#TODO, fix demo display
		text = " Season: %s \n Month: %d \n Week: %s / %d" % [seasons[season], month, date, days_in_month]
	Player.play_song(seasons[season])
