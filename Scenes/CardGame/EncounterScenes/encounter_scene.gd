class_name CardGameEncounterScene
extends Control

@export var background: Texture2D
@export_multiline var victory_reward: String #Use JSON formatted string, will be parsed
@export_multiline var starting_status_enemy: String #Use JSON formatted string, will be parsed
@export_multiline var starting_status_player: String #Use JSON formatted string, will be parsed
@export var background_music: AudioStream
