extends GridContainer

var locations = Constants.locations
var is_updating := false

func update_buttons(card_list:String = "draw_pile"):
	if is_updating:
		return
	else:
		is_updating = true
	var current_children = {}
	for node in get_children():
		if node.card_ui.card.id in current_children:
			current_children[node.card_ui.card.id].append(node)
		else:
			current_children[node.card_ui.card.id] = [node]
			
	var pile = []
	match card_list:
		"draw_pile":
			pile = Player.card_game_player.draw_pile.duplicate()
			pile.shuffle()
		"discard":
			pile = Player.card_game_player.discard.duplicate()
	
	for card: CardResource in pile:
		if card.id in current_children.keys():
			current_children[card.id].pop_back()
			if !current_children[card.id]:
				current_children.erase(card.id)
			continue
			
		var button:CardButton = load("res://Scenes/UI/Actions/card_button.tscn").instantiate()
		Player.background_thread.start(self.call_deferred.bind("add_child", button))
		await Player.background_thread.wait_to_finish()
		if !button.is_node_ready():
			await button.ready

		button.card_ui.card = card
		button.card_ui.current_state = button.card_ui.States.SPELLBOOK
		button.card_ui.set_deferred("disabled", true)
		button.tooltip_text = button.card_ui.tooltip_text
		button.button.disabled = true

	for key in current_children.keys():
		for node in current_children[key]:
			node.queue_free()
		current_children.erase(key)
	is_updating = false

