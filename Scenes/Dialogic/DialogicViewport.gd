extends SubViewportContainer

var style
@onready var viewport = $DialogicViewport

#TODO, integrate viewport with main scene dialogic calls
func _ready():
	style = Dialogic.Styles.load_style("NoBackgroundStyle", viewport)
	Dialogic.start_timeline("timeline")
