extends ItemList

@onready var plan_label = $PlanLabel

func _ready():
	visibility_changed.connect(update_buttons)
	
#TODO, add tooltip
#TODO, last clicked description should be displayed, add course with different button
func add_action(action_type:String, action_name:String):
	#Moves course to front if already in list
	var current_action_amount = len(Player.mandatory_daily_schedule_list) + len(Player.daily_schedule_list)

	var action = Constants[action_type][action_name]
	var cost = 0
	if action_name == "Cram School":
		#Lets Mao go to cram school even if it would put her below 0, just not too far below
		cost = 100
	else:
		if action.stats.get("gold"):
			cost = -action.stats.get("gold")
	#Don't queue actions if you don't have the gold to pay
	if cost > 0:
		if Player.stats.gold - cost < 0:
			ToastParty.show({
				"text": "You don't have the gold to pay for this. " + "(" + str(cost) + ")",
				"gravity": "top",
				"direction": "center",
			})
			return
			
	
	if current_action_amount >= Player.daily_action_limit:
		if Player.daily_schedule_list:
			Player.daily_schedule_list.pop_back()
			#format metadata {"action_type": action_type, "action_name": action_name}
			Player.daily_schedule_list.push_front({"action_type": action_type, "action_name": action_name})
		else:
			ToastParty.show({
				"text": "Your schedule can't be changed right now.",
				"gravity": "top",
				"direction": "center",
			})
	else:
		Player.daily_schedule_list.push_front({"action_type": action_type, "action_name": action_name})
	
	var data = {"action_type": action_type, "action_name": action_name}
	get_tree().call_group("ActionDetails", "display_stats", data)
	display_actions()

func display_actions():
	#Remove excess actions (mostly a concern if we added a mandatory action)
	var current_action_amount = len(Player.mandatory_daily_schedule_list) + len(Player.daily_schedule_list)
	
	plan_label.text = "Daily Schedule %d / %d" %[current_action_amount, Player.daily_action_limit]
	while current_action_amount > Player.daily_action_limit and Player.daily_schedule_list:
		Player.daily_schedule_list.pop_back()
	clear()
	#format metadata {"action_type": action_type, "action_name": action_name}
	for mandatory_action in Player.mandatory_daily_schedule_list:
		var icon = null
		if Constants[mandatory_action.action_type][mandatory_action.action_name].get("icon"):
			icon = load(Constants[mandatory_action.action_type][mandatory_action.action_name].get("icon"))
		if Constants.constants.ACTION_LABELS.get(mandatory_action.action_type):
			add_item(Constants.constants.ACTION_LABELS.get(mandatory_action.action_type), icon)
		else:
			add_item(mandatory_action.action_name, icon)
		set_item_metadata(item_count-1, mandatory_action)
		
		
		var desc = Constants[mandatory_action.action_type][mandatory_action.action_name].get("description")
		var tooltip = mandatory_action.action_name
		if desc:\
			tooltip += "\n\n" + desc
		set_item_tooltip(item_count-1, tooltip)
	
	for action in Player.daily_schedule_list:
		var icon = null
		if Constants[action.action_type][action.action_name].get("icon"):
			icon = load(Constants[action.action_type][action.action_name].get("icon"))
		if Constants.constants.ACTION_LABELS.get(action.action_type):
			add_item(Constants.constants.ACTION_LABELS.get(action.action_type), icon)
		else:
			add_item(action.action_name, icon)
		set_item_metadata(item_count-1, action)
		var desc = Constants[action.action_type][action.action_name].get("description")
		var tooltip = action.action_name
		if desc:\
			tooltip += "\n\n" + desc
		set_item_tooltip(item_count-1, tooltip)
	

func update_buttons():
	display_actions()
	get_tree().call_group("ActionDetails", "display_default_text")

func display_stats():
	display_actions()

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)
