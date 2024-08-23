extends VBoxContainer

@onready var buttons = $MarginContainer3/MenuPanel/HBoxContainer
@onready var pos1 = $MarginContainer/HBoxContainer/Enemy/PanelContainer/VBoxContainer
@onready var pos2 = $MarginContainer/HBoxContainer/Enemy2/PanelContainer/VBoxContainer

var enemy = Enemy.new()

var base_stats = ['max_hp', 'max_mp', 'strength', 'magic', 'skill', 'speed',
		'defense', 'resistance']
		
func _ready():
	
	#TODO dynamically load portraits based on enemies & display or hide panel container to indicate target
	var node = Enemy.new()
	node.name = "Enemy"
	pos2.get_node("Portrait").texture = load(node.portrait)
	pos2.add_child(node)
	update_hp(pos2)
	
	for button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed(button):
	print(button.text)
	match button.text:
		'Attack':
			#TODO, add targeting
			var damage = Player.stats.strength - pos2.get_node("Enemy").stats.defense
			update_hp(pos2, -damage)
		_:
			print("hello else")

	pass # Replace with function body.

func update_hp(pos: Node, change: int = 0) -> void:
	pos.get_node("Enemy").stats.current_hp += change
	pos.get_node("Hp").text = "Hp: " + str(pos.get_node("Enemy").stats.current_hp)
