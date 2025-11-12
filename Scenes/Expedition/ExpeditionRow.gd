class_name ExpeditionRow
extends HBoxContainer

@export var number_of_options:int = 3
@export var expedition_name:String = "Dumpling Dungeon"

signal option_selected

func update() -> void:
	for child in get_children():
		child.queue_free()
	for i in range(number_of_options):
		if !(expedition_name in Constants.expedition):
			printerr("No expedition_name for update in ExpeditionRow")
			return
		var expedition_data = Constants.expedition[expedition_name]
		var expedition_option:ExpeditionOption = load("res://Scenes/Expedition/expedition_option.tscn").instantiate()
		
		var weights = []
		var options = expedition_data.options
		for option in options:
			if ('weight' in option):
				var weight = option.weight
				weights.append(weight)
			else:
				weights.append(1)
				
		var option_data = options[Player.rand_weighted(weights)]
		add_child(expedition_option)
		expedition_option.button.icon = load(option_data.icon)
		expedition_option.combat = option_data.get("encounter_scene", "")
		expedition_option.timeline = option_data.get("timeline", "")
		expedition_option.option_selected.connect(on_option_selected)

func on_option_selected(combat, timeline):
	option_selected.emit(combat, timeline)
