class_name Deck
extends Resource

signal deck_size_changed(deck_size)

@export var cards: Array[CardResource] = []

func empty() -> bool:
	return cards.is_empty()

func draw_card() -> CardResource:
	var card = cards.pop_back()
	deck_size_changed.emit(cards.size())
	return card
