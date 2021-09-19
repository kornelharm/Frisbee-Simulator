extends Label

var camera

func _ready():
	camera = Globals.player.get_node("Camera")

func _process(delta):
	self.set_text("Aim: " + str(Globals.cameraAim))
