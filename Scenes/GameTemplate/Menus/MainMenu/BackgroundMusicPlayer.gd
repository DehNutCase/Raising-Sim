extends AudioStreamPlayer
var spring_song = preload("res://Music/Last Adventure 87 no afterglow.wav")
var summer_song = preload("res://Music/Chiptune Dream Loop.wav")
var autumn_song = preload("res://Music/New Road Loop.wav")
var winter_song = preload("res://Music/Walk Alone 80 no afterglow.wav")
var battle_song = preload("res://Music/8Bit DNA Loop.wav")
var no_exit_song = preload("res://Music/No Exit 106 no afterglow.wav")
var songs = {
	"spring": spring_song,
	"summer": summer_song,
	"autumn": autumn_song,
	"winter": winter_song,
	"battle": battle_song,
	"no_exit": no_exit_song, #Currently not used
}

func _ready():
	play_song("Spring")
	
func play_song(song:String) -> void:
		
	song = song.to_lower()
	if stream != songs[song]:
		for i in range(5):
			await get_tree().create_timer(.1).timeout
			volume_db -= 2
		stream = songs[song]
		play()
		for i in range(5):
			await get_tree().create_timer(.1).timeout
			volume_db += 2
	return
