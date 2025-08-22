class_name TalentTree
extends ScrollContainer

@onready var talent_rows = %TalentRows
@onready var talent_point_display:TalentPointDisplay = %TalentPointDisplay

func _ready() -> void:
	visibility_changed.connect(_update_rows)

#Use modulate to signify disabled talent choices
func _update_rows() -> void:
	talent_point_display.update_label()
	
	for node in talent_rows.get_children():
		talent_rows.remove_child(node)
		node.queue_free()
	
	for i in range(Constants.constants.TALENT_TIERS):
		var row = load("res://Scenes/TalentTree/talent_row.tscn").instantiate()
		talent_rows.add_child(row)
			
		for talent in Constants.talents:
			if i == Constants.talents[talent].tier:
				var talent_button: TalentButton = load("res://Scenes/TalentTree/talent_button.tscn").instantiate()
				talent_button.talent = talent
				row.add_child(talent_button)

