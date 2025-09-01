extends Sprite2D

var rotation_time:float = 0
@export var rotation_frequency: float = 1
@export_range(0,1) var amp: float = 2
var rotation_offset:float = 0

@onready var background = %Background

var success_sprite = preload("res://Characters/Mao/Images/exp_02_000.png")
var fail_sprite = preload("res://Characters/Mao/Images/exp_05_000.png")
var collapsed_sprite = preload("res://Art/KikariStore/l2d.png")
var proud_sprite = preload("res://Art/KikariStore/m1e.png")

func _ready() -> void:
	walk_animation("failure")

func _process(delta) -> void:
	rotation = sin(rotation_time * rotation_frequency) * PI * amp + rotation_offset
	rotation_time += delta
	pass

func walk_animation(walk_type="success", walk_background="res://Art/Background/Background material shop/bg007a.bmp") -> void:
	background.texture=load(walk_background)
	match walk_type:
		"success":
			texture = success_sprite
			var tween := create_tween().set_trans(Tween.TRANS_SPRING)
			var start: Vector2 = global_position
			var end := Vector2(2000, 800)
			show()
			tween.tween_property(self, "global_position", end, 3)
			await tween.finished
			global_position = start
			hide()
			background.texture = proud_sprite
			background.flip_h = true
		"failure":
			texture = fail_sprite
			var tween := create_tween().set_trans(Tween.TRANS_SPRING)
			var start: Vector2 = global_position
			var end := Vector2(1000, 800)
			show()
			tween.tween_property(self, "global_position", end, 2.5)
			#await get_tree().create_timer(2).timeout
			tween.chain().tween_property(self, "rotation_offset", PI/1.8, 1)
			await tween.finished
			global_position = start
			hide()
			background.texture = collapsed_sprite
		_:
			printerr("walk_animation failed to match type")
