class_name TalentButton
extends VBoxContainer

@onready var stack_label = %StackLabel
@onready var talent_texture = %TalentTexture
@onready var icon_container = %IconContainer
@onready var lock_texture = %LockTexture

var DISABLED_MODULATE = Color(.5,.5,.5,.5)
var ENABLED_MODULATE = Color(1,1,1,1)

var talent = "cheerful"
var tier = 0
var stacks = 0
var max_stacks = 1

func _ready() -> void:
	update_labels()

#returns true if not enough talent points have been spent to unlock the tier
func check_locked() -> bool:
	if Player.talent_points_spent >= tier * 5:
		lock_texture.hide()
		return false
	lock_texture.show()
	return true
	
func update_labels() -> void:
	if Constants.talents.get(talent):
		var talent_data = Constants.talents.get(talent)
		talent_texture.icon = load(talent_data.get("icon"))
		
		tier = talent_data.tier
		check_locked()
		
		if Player.talent_tree.get(talent):
			stacks = Player.talent_tree.get(talent)
		else:
			stacks = 0
		if talent_data.get("max_stacks"):
			max_stacks = talent_data.get("max_stacks")
		else:
			max_stacks = 1
		stack_label.text = "%d / %d" % [stacks, max_stacks]
		if stacks == 0:
			icon_container.modulate = DISABLED_MODULATE
		else:
			icon_container.modulate = ENABLED_MODULATE
		icon_container.tooltip_text = make_tooltip()


func make_tooltip() -> String:
	var talent_data = Constants.talents.get(talent)
	if !talent_data:
		return ""
	var tooltip = talent_data.get("label")
	if tooltip: tooltip += "\n\n"
	tooltip += talent_data.get("description")
	tooltip += "\n"
	var daily_stats:Dictionary = talent_data.get("daily_stats", {})
	if (!daily_stats.keys().is_empty()):
		tooltip += "\nDaily Stats:"
		for stat in daily_stats.keys():
			tooltip += " "
			if (daily_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(daily_stats[stat]) + " " + Constants.stats[stat].label
	
	var stats:Dictionary = talent_data.get("stats", {})
	if (!stats.keys().is_empty()):
		tooltip += "\nStats:"
		for stat in stats.keys():
			tooltip += " "
			if (stats[stat] > 0):
				tooltip += "+"
			tooltip += str(stats[stat]) + " " + Constants.stats[stat].label
			
	var monthly_stats:Dictionary = talent_data.get("monthly_stats", {})
	if (!monthly_stats.keys().is_empty()):
		tooltip += "\nMonthly Stats:"
		for stat in monthly_stats.keys():
			tooltip += " "
			if (monthly_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(monthly_stats[stat]) + " " + Constants.stats[stat].label
	
	var max_stats:Dictionary = talent_data.get("max_stats", {})
	if (!max_stats.keys().is_empty()):
		tooltip += "\nMax Stats:"
		for stat in max_stats.keys():
			tooltip += " "
			if (max_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(max_stats[stat]) + " " + Constants.stats[stat].label
	
	var min_stats:Dictionary = talent_data.get("min_stats", {})
	if (!min_stats.keys().is_empty()):
		tooltip += "\nMin Stats:"
		for stat in min_stats.keys():
			tooltip += " "
			if (min_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(min_stats[stat]) + " " + Constants.stats[stat].label

	var level_up_stats:Dictionary = talent_data.get("level_up_stats", {})
	if (!level_up_stats.keys().is_empty()):
		tooltip += "\nLevel Up Stats:"
		for stat in level_up_stats.keys():
			tooltip += " "
			if (level_up_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(level_up_stats[stat]) + " " + Constants.stats[stat].label
			
	if check_locked():
		var talent_points_needed = tier * 5 - Player.talent_points_spent
		tooltip += "\n\nYou need to spend %d more talent points to unlock this tier." %talent_points_needed
	return tooltip
	

func _on_talent_texture_pressed():
	if check_locked():
		var talent_points_needed = tier * 5 - Player.talent_points_spent
		var toast = "You need to spend %d more talent points to unlock this tier." %talent_points_needed
		Player.display_toast(toast)
		return
		
	var talent_data = Constants.talents.get(talent)
	if Player.stats.talent_points <  talent_data.cost:
		var talent_points_needed = tier * 5 - Player.talent_points_spent
		var toast = "You can't afford this talent! (It costs %d talent points and you only have %d.)" % [talent_data.cost, Player.stats.talent_points]
		Player.display_toast(toast)
		return
		
	if stacks < max_stacks:
		get_tree().call_group("Main", "_on_talent_button_pressed", talent)
		Player.play_ui_sound("blop")
