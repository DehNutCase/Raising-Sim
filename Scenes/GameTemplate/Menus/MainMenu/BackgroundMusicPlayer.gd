extends AudioStreamPlayer
var spring_song = preload("res://Music/Last Adventure 87 no afterglow.wav")
var summer_song = preload("res://Music/Chiptune Dream Loop.wav")
var autumn_song = preload("res://Music/New Road Loop.wav")
var winter_song = preload("res://Music/Walk Alone 80 no afterglow.wav")
var songs = {
	"spring": spring_song,
	"summer": summer_song,
	"autumn": autumn_song,
	"winter": winter_song,
}

func _ready():
	play_song("spring")
	
func play_song(song:String) -> void:
	#TODO, add fadein/out
	if stream != songs[song]:
		stream = songs[song]
		play()
	return
