extends GDCubismEffectTargetPoint
var return_to_neutral := false

func _process(delta):
	if active and !return_to_neutral:
		var adjust_pos = Vector2(%PlayerModel.size.x * .5, %PlayerModel.size.y * .5 - 170)
		var local_pos = %PlayerSprite.to_local(%PlayerSprite.get_global_mouse_position())
		local_pos -= adjust_pos
		
		var render_size: Vector2 = Vector2(
			float(%PlayerModel.size.x) ,
			float(%PlayerModel.size.y) * -1.0
		)
		local_pos /= (render_size * 0.5)
		
		set_target(local_pos)
	else:
		set_target(Vector2.ZERO)

func activate():
	active = true
	return_to_neutral = false

func deactivate():
	return_to_neutral = true
	await get_tree().create_timer(1).timeout
	active = false
