extends GridContainer

var locations = Constants.locations

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_buttons)

#TODO, optimize this (check if card is shown, if not, add it, if it's not in deck, remove it)
func update_buttons():
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for card: CardResource in Player.card_game_deck:
		var button: CardButton = load("res://Scenes/UI/Actions/card_button.tscn").instantiate()
		add_child(button)
		button.card_ui.card = card
		button.tooltip_text = button.card_ui.tooltip_text
