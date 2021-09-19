extends Label

func _process(delta):
	self.set_text("Yaw: " + str(rad2deg(Globals.player.rotation_angle)))
