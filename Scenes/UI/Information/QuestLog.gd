extends MarginContainer

@onready var quest_list = %QuestList
@onready var quest_description = %QuestDescriptionLabel
@onready var complete_quest_button = %CompleteQuestButton

var last_quest: String

func _ready() -> void:
	visibility_changed.connect(update_quests)

func update_quests() -> void:
	#TODO, only do this for quests in player.active_quests
	quest_list.clear()
	for quest in Constants.quests:
		var quest_data = Constants.quests[quest]
		var completed = ""
		if check_quest_completion(quest):
			completed = "✅ "
		else:
			completed = "❌ "
		var index = quest_list.add_item(completed+ quest_data.name)
		quest_list.set_item_tooltip(index, quest_data.description)
		quest_list.set_item_metadata(index, {"id": quest})
	
	if last_quest:
		display_quest(last_quest)
	elif quest_list.get_item_metadata(0):
		var quest = quest_list.get_item_metadata(0).id
		last_quest = quest
		display_quest(quest)

#TODO, mark progress via icon?
func _on_quest_list_item_clicked(index, at_position, mouse_button_index):
	var data = quest_list.get_item_metadata(index)
	var quest = data.id
	last_quest = quest
	display_quest(quest)

func display_quest(quest: String) -> void:
	quest_description.clear()
	quest_description.append_text(Constants.quests[quest].name + "\n\n")
	quest_description.append_text(Constants.quests[quest].description)
	complete_quest_button.disabled = !check_quest_completion(quest)

#TODO, check quest requirements
func check_quest_completion(quest: String):
	var quest_requirements = Constants.quests[quest].requirements
	if 'stats' in quest_requirements:
		for stat in quest_requirements.stats:
			if quest_requirements.stats[stat] > Player.stats[stat]:
				return true
	return true

func _on_complete_quest_button_pressed():
	if !last_quest:
		return
	if check_quest_completion(last_quest):
		#TODO, implement giving rewards and removing quest from list of active quests
		print("completed!")
	else:
		#might not need this section
		print("incomplete")
