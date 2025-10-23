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
	var tooltip = Player.make_stat_tooltip(talent_data)
			
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
