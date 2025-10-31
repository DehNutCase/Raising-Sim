extends GDCubismEffectTargetPoint

func _process(delta):
	if active:
		var adjust_pos = Vector2(%PlayerModel.size.x * .5, %PlayerModel.size.y * .5 - 170)
		var local_pos = %PlayerSprite.to_local(%PlayerSprite.get_global_mouse_position())
		local_pos -= adjust_pos
		
		var render_size: Vector2 = Vector2(
			float(%PlayerModel.size.x) ,
			float(%PlayerModel.size.y) * -1.0
		)
		local_pos /= (render_size * 0.5)
		
		set_target(local_pos)
