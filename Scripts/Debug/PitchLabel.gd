extends Label

func _process(delta):
	self.set_text("Pitch: " + str(Globals.cameraPitch))
