extends Label

func _process(delta):
	self.set_text("Velocity: " + str(Globals.velocity))
