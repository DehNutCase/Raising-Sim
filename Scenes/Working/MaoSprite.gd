extends Sprite2D

var rotation_time:float = 0
@export var rotation_frequency: float = 1
@export_range(0,1) var amp: float = 1
var rotation_offset:float = 0

@onready var background = %Background
@onready var result_sprite = %ResultSprite
@onready var job_icon = %JobIcon

var success_sprite = preload("res://Characters/Mao/Images/exp_02_000.png")
var fail_sprite = preload("res://Characters/Mao/Images/exp_05_000.png")
var collapsed_sprite = preload("res://Art/KikariStore/l2d.png")
var proud_sprite = preload("res://Art/KikariStore/m1e.png")

func _process(delta) -> void:
	if is_visible_in_tree():
		rotation = sin(rotation_time * rotation_frequency) * PI * amp + rotation_offset
		rotation_time += delta

func walk_animation(walk_type="success", walk_background="res://Art/Background/Background material shop/bg007a.bmp", job_texture="res://Art/Mori no oku no kakurezato/Job Icons/Resized/bag04_01.png") -> void:
	background.texture=load(walk_background)
	var start: Vector2 = global_position
	result_sprite.hide()
	job_icon.texture = load(job_texture)
	job_icon.show()
	match walk_type:
		"success":
			texture = success_sprite
			var tween := create_tween().set_trans(Tween.TRANS_SPRING)
			var end := Vector2(1850, 700)
			show()
			tween.tween_property(self, "global_position", end, 3)
			await tween.finished
			hide()
			result_sprite.texture = proud_sprite
			result_sprite.flip_h = true
		"failure":
			texture = fail_sprite
			var tween := create_tween().set_trans(Tween.TRANS_SPRING)
			var end := Vector2(1000, 700)
			show()
			tween.tween_property(self, "global_position", end, 2.5)
			tween.chain().tween_property(self, "rotation_offset", PI/1.8, .5)
			await tween.finished
			hide()
			result_sprite.texture = collapsed_sprite
		_:
			printerr("walk_animation failed to match type")
	result_sprite.show()
	job_icon.hide()
	rotation_offset = 0
	global_position = start
	await get_tree().create_timer(2).timeout
	result_sprite.flip_h = false
