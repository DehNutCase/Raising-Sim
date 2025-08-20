extends VBoxContainer


func _ready() -> void:
	_update_rows()

#Use modulate to signify disabled talent choices
func _update_rows() -> void:
	for i in range(Constants.constants.TALENT_TIERS):
		var row = load("res://Scenes/TalentTree/talent_row.tscn").instantiate()
		add_child(row)
		for talent in Constants.talents:
			if i == Constants.talents[talent].tier:
				var talent_button: TalentButton = load("res://Scenes/TalentTree/talent_button.tscn").instantiate()
				talent_button.talent = talent
				row.add_child(talent_button)
		
	pass
