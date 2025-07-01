extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_quests)

func update_quests():
	pass
