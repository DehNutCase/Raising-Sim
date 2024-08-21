extends VBoxContainer

@onready var buttons = $MarginContainer3/MenuPanel/HBoxContainer
@onready var enemy1 = $MarginContainer/HBoxContainer/TextureRect
var enemy = Enemy.new()

var base_stats = ['max_hp', 'max_mp', 'strength', 'magic', 'skill', 'speed',
		'defense', 'resistance']
		
func _ready():
	#TODO dynamically load portraits based on enemies
	enemy1.texture = load(enemy.portrait)
	for button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Constants
	pass


func _on_button_pressed(button):
	print(button.text)
	pass # Replace with function body.
