extends SubViewportContainer

var style
@onready var viewport = $DialogicViewport

func _ready():
	style = Dialogic.Styles.load_style("NoBackgroundStyle", viewport)
	Dialogic.start_timeline("timeline")
