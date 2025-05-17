extends Node


func play(audio: AudioStream, single=false) -> void:
	if not audio:
		return
		
	if single:
		stop()

	for CardGamePlayer: AudioStreamPlayer in get_children():
		if not CardGamePlayer.playing:
			CardGamePlayer.stream = audio
			CardGamePlayer.play()
			break


func stop() -> void:
	for CardGamePlayer: AudioStreamPlayer in get_children():
		CardGamePlayer.stop()
