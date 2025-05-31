extends GridContainer

var locations = Constants.locations
var cache = []

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_buttons)

func update_buttons():
	if cache.hash() == Player.card_game_deck.hash():
		return
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for card: CardResource in Player.card_game_deck:
		cache.append(card)
		var button: CardButton = load("res://Scenes/UI/Actions/card_button.tscn").instantiate()
		add_child(button)
		button.card_ui.card = card
