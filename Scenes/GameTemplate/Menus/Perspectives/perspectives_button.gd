class_name PerspectivesButton
extends MarginContainer

@onready var button_label = $Button/Label
var timeline = ""
var perspective = "":
	set(value):
		perspective = value
		check_requirements()

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(call_deferred.bind("check_requirements"))

func check_requirements() -> void:
	#Check requirements here, and blank & disable if not met
	if !perspective or (!Player.perspectives.get(perspective) and !Constants.perspectives[perspective].get("unlock")):
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
