extends Control

@onready var portrait = $VBoxContainer/Portrait
@onready var hp = $VBoxContainer/Hp
@onready var target_panel = $TargetPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_hp(change: int = 0) -> void:
	get_node("Enemy").stats.current_hp += change
	hp.text = get_node("Enemy").label + "\n" + "Hp: " + str(get_node("Enemy").stats.current_hp)

func get_hp() -> int:
	return get_node("Enemy").stats.current_hp
	
func update_portrait() -> void:
	portrait.texture = load(get_node("Enemy").portrait)
	target_panel.custom_minimum_size = Vector2((150 * portrait.texture.get_size().x/portrait.texture.get_size().y) + 20, 150 + 20 )

func toggle_target(toggle: bool) -> void:
	target_panel.visible = toggle;
