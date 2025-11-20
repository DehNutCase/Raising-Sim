extends MarginContainer

@onready var quest_list: ItemList = %QuestList
@onready var quest_description = %QuestDescription
@onready var complete_quest_button = %CompleteQuestButton

var last_quest: String

func _ready() -> void:
	visibility_changed.connect(call_deferred.bind("update_quests"))

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
	
	var fail_conditions = Constants.quests[quest].get("failure_conditions")
	if fail_conditions:
		if fail_conditions.get("day"):
			var day = fail_conditions.day
			day -= 1
			var days_in_month = Constants.constants.days_in_month
			var month:int = ((day / (days_in_month)) % Constants.constants.months_in_year) + 1
			var date: int = day % days_in_month + 1
			var text = "Time Limit: Month %d, Week %s" % [month, date]
			quest_description.append_text(text + "\n\n")
		elif fail_conditions.get("one_day"):
			quest_description.append_text("This quest needs to be finished before the end of the week.\n\n")
	
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
	
	if 'work' in quest_requirements:
		quest_description.append_text("\n")
		var works = []
		for work in quest_requirements.work:
			var label = work
			var check_mark = "✅"
			if quest_requirements.work[work] > Player.active_quests[quest].work[work]:
				check_mark = "❌"
			label += ": " + str(Player.active_quests[quest].work[work]) +  " / " + str(quest_requirements.work[work]) + check_mark
			works.append(label)
			
		var text = ", ".join(works)
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
	if 'work' in quest_requirements:
		var active_quest_info = Player.active_quests.get(quest)
		for work in quest_requirements.work:
			if !active_quest_info.get("work"):
				active_quest_info.work = {}
			if !active_quest_info.work.get(work):
				active_quest_info.work[work] = 0
			if active_quest_info.work[work] < quest_requirements.work[work]:
				return false
	return true

func quest_work_progress(work: String):
	for quest in Player.active_quests:
		var quest_requirements = Constants.quests[quest].requirements
		if 'work' in quest_requirements:
			var active_quest_info = Player.active_quests.get(quest)
			if !active_quest_info.get("work"):
				active_quest_info.work = {}
			if !active_quest_info.work.get(work):
				active_quest_info.work[work] = 0
			active_quest_info.work[work] += 1

#TODO, process failures here or elsewhere?
#TODO, make quest chains that start a new quest when one is completed. 30d total, so 7 days time limit for each.
func check_quest_failure(quest: String):
	var quest_info = Constants.quests[quest]
	#quest is only failed if you haven't completed it
	if 'failure_conditions' in quest_info and !check_quest_completion(quest):
		var failure_conditions = quest_info.failure_conditions
		if 'day' in failure_conditions:
			if Player.day > failure_conditions.day:
				await process_quest_failure(quest)
				return true
		if 'one_day' in failure_conditions:
			process_quest_failure(quest)
			return true
	return false

func check_quests_failure():
	for quest in Player.active_quests:
		await check_quest_failure(quest)
	
func process_quest_failure(quest: String):
	var quest_info = Constants.quests[quest]
	Player.active_quests.erase(quest)
	if quest == last_quest:
		last_quest = ""
	if 'failure_rewards' in quest_info:
		get_tree().call_group("Main", "_on_reward_signal", quest_info.failure_rewards)
		if 'timeline' in quest_info.failure_rewards:
			await Dialogic.timeline_ended

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
