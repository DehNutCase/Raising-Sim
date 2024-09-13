class_name SkillList
extends ItemList

func _make_custom_tooltip(tooltipText):
	var tooltip = preload("res://Scenes/UI/Tooltip.tscn").instantiate()
	tooltip.text = tooltipText
	return tooltip
