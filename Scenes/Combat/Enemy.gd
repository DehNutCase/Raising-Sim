extends Control

@onready var portrait = $VBoxContainer/Portrait
@onready var hp = $VBoxContainer/Hp
@onready var target_panel:PanelContainer = $TargetPanel

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
	#TODO, figure out how to properly size target panel
	target_panel.custom_minimum_size = Vector2(150 + 20, + (150/portrait.texture.get_size().x * portrait.texture.get_size().y) + 20)
	target_panel.position = Vector2(-10, 0)

func toggle_target(toggle: bool) -> void:
	target_panel.visible = toggle;
