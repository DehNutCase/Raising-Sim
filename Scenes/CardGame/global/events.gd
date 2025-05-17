extends Node

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

# CardGamePlayer-related events
signal CardGamePlayer_hand_drawn
signal CardGamePlayer_hand_discarded
signal CardGamePlayer_turn_ended
signal CardGamePlayer_hit
signal CardGamePlayer_died

# CardGameEnemy-related events
signal enemy_action_completed(enemy: CardGameEnemy)
signal enemy_turn_ended

# Battle-related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
