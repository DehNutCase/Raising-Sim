class_name CardGameEncounterScene
extends Control

@export var background: Texture2D
@export_multiline var victory_reward: String #Use JSON formatted string, will be parsed
@export_multiline var defeat_reward: String #Use JSON formatted string, will be parsed
@export var starting_status_enemy: Array[CardGameStatusResource]
@export var starting_status_stacks_enemy: Array[int]
@export var starting_status_player: Array[CardGameStatusResource]
@export var starting_status_stacks_player: Array[int]
@export var background_music: AudioStream
