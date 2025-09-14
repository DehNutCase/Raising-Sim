extends GridContainer

var locations = Constants.locations

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_buttons)

func update_buttons():
	var current_children = {}
	for node in get_children():
		if node.card_ui.card.id in current_children:
			current_children[node.card_ui.card.id].append(node)
		else:
			current_children[node.card_ui.card.id] = [node]
	
	for card: CardResource in Player.card_game_deck:
		if card.id in current_children.keys():
			current_children[card.id].pop_back()
			if !current_children[card.id]:
				current_children.erase(card.id)
			continue
		
		var button: CardButton = load("res://Scenes/UI/Actions/card_button.tscn").instantiate()
		add_child(button)
		button.card_ui.card = card
		button.card_ui.current_state = button.card_ui.States.SPELLBOOK
		button.tooltip_text = button.card_ui.tooltip_text

	for key in current_children.keys():
		for node in current_children[key]:
			node.queue_free()
		current_children.erase(key)
