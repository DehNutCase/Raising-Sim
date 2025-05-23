class_name CardGameStatusResource
extends Resource

@export var status_icon: Texture
@export var status_name: String
@export_multiline var status_tooltip: String
enum DecayType {START_OF_TURN, END_OF_TURN, PERMANENT, ONE_TURN}
@export var status_decay: DecayType
@export var NegativeStatus: bool
