extends GridContainer

var locations = Constants.locations
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_buttons():
	for card: CardResource in Player.card_game_deck:
		var button: CardButton = load("res://Scenes/UI/Actions/card_button.tscn").instantiate()
		add_child(button)
		button.card_ui.card = card
