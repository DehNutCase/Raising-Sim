class_name EndingsButton
extends MarginContainer

@onready var button_label = $Button/Label
var timeline = ""
var ending = "":
	set(value):
		ending = value
		check_requirements()

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(call_deferred.bind("check_requirements"))

func check_requirements() -> void:
	#Check requirements here, and blank & disable if not met
	#Endings are saved with perspectives to save space
	if !ending or !Player.perspective.get(ending):
		update_icon(load("res://Art/Background/BlackBackground.png"))
		#maybe leave label alone?
		update_label("???")
		%Button.disabled = true
	 
func update_label(text: String):
	button_label.text = text

func update_icon(icon: Texture2D):
	%Button.icon = icon

func _on_job_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	Dialogic.start(timeline)
	await Dialogic.timeline_ended
	#Start perspective timeline here
