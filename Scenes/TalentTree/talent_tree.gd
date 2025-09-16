class_name TalentTree
extends ScrollContainer

@onready var talent_rows = %TalentRows
@onready var talent_point_display:TalentPointDisplay = %TalentPointDisplay
var rows = []

func _ready() -> void:
	visibility_changed.connect(_update_rows)

#Use modulate to signify disabled talent choices
func _update_rows() -> void:
	talent_point_display.update_label()
	
	var current_children = {}
	for row in rows:
		for node in row.get_children():
			if node.talent in current_children:
				current_children[node.talent].append(node)
			else:
				current_children[node.talent] = [node]
	
	var has_rows = false
	if rows:
		has_rows = true
	for i in range(Constants.constants.TALENT_TIERS):
		var row: HBoxContainer
		if !has_rows:
			row = load("res://Scenes/TalentTree/talent_row.tscn").instantiate()
			talent_rows.add_child(row)
			rows.append(row)
		else:
			row = rows[i]
			
		for talent in Constants.talents:
			if i == Constants.talents[talent].tier:
				if talent in current_children.keys():
					current_children[talent].pop_back()
					if !current_children[talent]:
						current_children.erase(talent)
					continue
				var talent_button: TalentButton = load("res://Scenes/TalentTree/talent_button.tscn").instantiate()
				talent_button.talent = talent
				row.add_child(talent_button)
	for key in current_children.keys():
		for node in current_children[key]:
			node.queue_free()
		current_children.erase(key)

