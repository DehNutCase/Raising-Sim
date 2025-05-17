class_name DamageEffect
extends Effect

var amount := 0


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is CardGameEnemy or target is CardGamePlayer:
			target.take_damage(amount)
			SFXCardGamePlayer.play(sound)
