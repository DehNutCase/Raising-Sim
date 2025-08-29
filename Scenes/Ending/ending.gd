extends Control

@onready var play_ending_button = %PlayEndingButton
@onready var ending_text:RichTextLabel = %EndingText

var ending = ""
var score = 0

func _ready() -> void:
	update_display()
	visibility_changed.connect(update_display)

func update_display() -> void:
	var calculated_ending: Array = Player.calculate_ending()
	ending = calculated_ending[2]
	score = calculated_ending[0]
	
	var ending_info = Constants.endings[ending]
	
	ending_text.clear()
	ending_text.append_text("Your current ending is: %s\n\nYour current score is: %d \n\n" %[ending_info.label, score])
	
	var description = Constants.endings[ending].get("description")
	if description:
		ending_text.append_text("\n\n" + description)


func _on_play_ending_button_pressed():
	get_tree().call_group("Main", "_on_play_ending_button_pressed")
