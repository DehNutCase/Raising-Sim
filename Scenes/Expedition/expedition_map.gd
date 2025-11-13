class_name ExpeditionMap
extends MarginContainer

var expedition_name:String = ""
@onready var background:TextureRect = %Background
@onready var expedition_row: ExpeditionRow = %ExpeditionRow
@onready var exploration_progress_label:Label = %ExplorationProgressLabel

signal choice_finished
signal choice_selected

func _ready() -> void:
	visibility_changed.connect(update)
	expedition_row.option_selected.connect(process_choice)

func update() -> void:
	if !expedition_name:
		printerr("No expedition_name for update in ExpeditionMap")
		return
	var expedition_data = Constants.expedition[expedition_name]
	background.texture = load(expedition_data.background)
	if "number_of_options" in expedition_data:
		expedition_row.number_of_options = expedition_data.number_of_options
	expedition_row.expedition_name = expedition_name
	await expedition_row.update()

func process_choice(combat:String, timeline:String) -> void:
	var main_node:Main = get_tree().get_first_node_in_group("Main")
	if !main_node:
		printerr("main_node doesn't exist while trying to process_choice for ExpeditionMap")
		return
	choice_selected.emit()
	if combat:
		main_node.enter_card_game(combat, false, false, true)
		await main_node.card_game_finished
		await get_tree().create_timer(1).timeout
		if Dialogic.current_timeline:
			await Dialogic.timeline_ended
	elif timeline:
		Dialogic.start(timeline)
		await Dialogic.timeline_ended
	else:
		printerr("Neither combat nor timeline in process_choice for ExpeditionMap")
		pass
	
	choice_finished.emit()

func exploration_progress_update(current_progress:int, needed_progress:int) -> void:
	exploration_progress_label.text = "Exploration Progress: %d / %d" % [current_progress, needed_progress]
