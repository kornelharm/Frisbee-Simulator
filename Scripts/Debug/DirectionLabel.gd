extends Label

func _process(delta):
	self.set_text("Direction: " + str(Globals.direction))
