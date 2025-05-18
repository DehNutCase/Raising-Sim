extends Node2D

@onready var hand = $UI/Hand
func _ready():
	for card:CardUI in hand.get_children():
		card.reparent_requested.connect(_on_card_ui_reparent_requested)
		
func _on_card_ui_reparent_requested(card):
	pass # Replace with function body.
