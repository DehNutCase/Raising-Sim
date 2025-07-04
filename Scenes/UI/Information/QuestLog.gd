extends MarginContainer

@onready var quest_list: ItemList = %QuestList
@onready var quest_description = %QuestDescription
@onready var complete_quest_button = %CompleteQuestButton

var last_quest: String

func _ready() -> void:
	visibility_changed.connect(update_quests)

func update_quests() -> void:
	#TODO, only do this for quests in player.active_quests
	quest_list.clear()
	for quest in Player.active_quests:
		var quest_data = Constants.quests[quest]
		var completed = ""
		if check_quest_completion(quest):
			completed = "✅ "
		else:
			#Only checkmark for completed instead of X for incomplete
			pass
			#completed = "❌ "
		var index = quest_list.add_item(completed+ quest_data.name)
		quest_list.set_item_tooltip(index, quest_data.description)
		quest_list.set_item_metadata(index, {"id": quest})
	
	if last_quest:
		display_quest(last_quest)
	elif quest_list.item_count:
		var quest = quest_list.get_item_metadata(0).id
		last_quest = quest
		display_quest(quest)
	else:
		display_no_quest()

#TODO, mark progress via icon?
func _on_quest_list_item_clicked(index, at_position, mouse_button_index):
	var data = quest_list.get_item_metadata(index)
	var quest = data.id
	last_quest = quest
	display_quest(quest)

func display_quest(quest: String) -> void:
	quest_description.clear()
	quest_description.append_text(Constants.quests[quest].name + "\n\n")
	quest_description.append_text("Description:" + "\n")
	quest_description.append_text(Constants.quests[quest].description + "\n\n")
	
	quest_description.append_text("Requirements:")
	var quest_requirements = Constants.quests[quest].requirements
	if 'stats' in quest_requirements:
		quest_description.append_text("\nStats: ")
		var stats = []
		for stat in quest_requirements.stats:
			var label = stat
			if ("label" in Constants.stats[stat]):
				label = Constants.stats[stat]["label"]
			if ("emoji" in Constants.stats[stat]):
				label += Constants.stats[stat].emoji
			var check_mark = "✅"
			if quest_requirements.stats[stat] > Player.stats[stat]:
				check_mark = "❌"
			label += ": " + str(Player.stats[stat]) +  " / " + str(quest_requirements.stats[stat]) + " " + check_mark
			stats.append(label)
		var text = ", ".join(stats)
		quest_description.append_text(text)
	
	if 'tower_level' in quest_requirements:
		quest_description.append_text("\nTower Level: ")
		var check_mark = "✅"
		if quest_requirements.tower_level > Player.tower_level:
			check_mark = "❌"
		var text = str(Player.tower_level) + " / " + str(quest_requirements.tower_level) + " " + check_mark
		quest_description.append_text(text)
	
	complete_quest_button.disabled = !check_quest_completion(quest)

func display_no_quest() -> void:
	quest_description.clear()
	quest_description.append_text("You don't have any quests right now.")

#TODO, check quest requirements
func check_quest_completion(quest: String):
	var quest_requirements = Constants.quests[quest].requirements
	if 'stats' in quest_requirements:
		for stat in quest_requirements.stats:
			if quest_requirements.stats[stat] > Player.stats[stat]:
				return false
	if 'tower_level' in quest_requirements:
		if quest_requirements.tower_level > Player.tower_level:
			return false
	return true

func _on_complete_quest_button_pressed():
	if !last_quest:
		return
	if check_quest_completion(last_quest):
		#TODO, implement giving rewards and removing quest from list of active quests
		var quest_info = Constants.quests[last_quest]
		get_tree().call_group("Main", "_on_reward_signal", quest_info.rewards)
		Player.active_quests.erase(last_quest)
		Player.completed_quests[last_quest] = true
		last_quest = ""
		update_quests()
	else:
		#might not need this section
		print("incomplete")
