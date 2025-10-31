class_name FloatingHeart
extends Sprite2D

var rotation_time:float = 0
##How often the sprite rotates
@export var rotation_frequency: float = 3
##How much the sprite rotates
@export var offset_amp: Vector2 = Vector2(50,0)

var happy_heart_sprite = preload("res://Art/Mori no oku no kakurezato/Skill Icon/Resized/heart_01.png")
var sad_heart_sprite = preload("res://Art/Mori no oku no kakurezato/Skill Icon/Resized/heartbreak_02.png")

func _ready() -> void:
	rotation_time = randi_range(0,10)
	rotation_frequency *= randf_range(.5,2)
	offset_amp *= randf_range(.5,2)

func _process(delta) -> void:
	if is_visible_in_tree():
		offset = sin(rotation_time * rotation_frequency) * PI * offset_amp
		rotation_time += delta

func float_animation(happy_heart:bool = true) -> void:
	var start_position: Vector2 = global_position
	match happy_heart:
		true:
			texture = happy_heart_sprite
			var tween:Tween = create_tween().set_trans(Tween.TRANS_SINE)
			var end := global_position + Vector2(0,-100) * randf_range(1, 2)
			tween.set_parallel()
			tween.tween_property(self, "global_position", end, 3)
			tween.tween_property(self, "modulate", Color.TRANSPARENT, 3)
			tween.tween_property(self, "scale", Vector2(.2,.2) * randf_range(.25,4), 3)
			await tween.finished
			queue_free()
		false:
			texture = sad_heart_sprite
			var tween:Tween = create_tween().set_trans(Tween.TRANS_SINE)
			var end := global_position + Vector2(0,-100) * randf_range(1, 2)
			tween.set_parallel()
			tween.tween_property(self, "global_position", end, 3)
			tween.tween_property(self, "modulate", Color.TRANSPARENT, 3)
			tween.tween_property(self, "scale", Vector2(.2,.2) * randf_range(.25,4), 3)
			await tween.finished
			queue_free()
		_:
			printerr("float_animation failed to match type")
