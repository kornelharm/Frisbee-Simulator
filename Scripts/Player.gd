extends KinematicBody


#Camera movement variables
var camera_angle = 0
export var mouse_sensitivity = 0.1

#Player movement variables
var velocity = Globals.velocity
var rotation_angle
var pitch
var globalPos

#Walking variables
export var gravity = -9.8
export var max_speed = 20
export var max_running_speed = 30
export var accel = 4
export var decel = 4

#Frisbee variables
var hasFrisbee

#Jump variables
export var jump_strength = 30

func _ready():
	Globals.velocity = Vector3()
	Globals.player = self
	Globals.giveFrisbee(self)

func _process(delta):
	globalPos = to_global(get_node("Camera").get_translation())
	Globals.cameraAim = $Camera.project_ray_normal(get_viewport().get_size()/2)
	if Input.is_action_just_pressed("fire"):
		if hasFrisbee:
			Globals.throwFrisbee(self)

func _physics_process(delta):
	if(not Globals.pauseState):
		walk(delta)
		pitch = $Camera.rotation_degrees.x
		Globals.cameraPitch = pitch

	
#Runs whenever an event is triggered, with the event as the argument for this function
func _input(event):
	if(not Globals.pauseState):
		#Checks to see if mouse movement is happening
		if event is InputEventMouseMotion:
			#Rotates the head node horizontally by a scaled value based on the changed mouse position horizontally 
			self.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			
			#Change in mouse movement in the y direction
			var change_y = -event.relative.y * mouse_sensitivity
			
			#If the change in y will not go outside these bounds
			if (change_y + camera_angle < 89.5) and (change_y + camera_angle > -89.5):
				#Rotates the head node vertically by a scaled value based on the changed mouse position vertically 
				$Camera.rotate_x(deg2rad(change_y))
				camera_angle += change_y
					
#Walks like a human would
func walk(delta):
	#Reset the direction of the player
	Globals.direction = Vector3()
	
	
	#Gets the normalized rotation of the camera
	Globals.aim = $Camera.get_global_transform()
	Globals.aim = Globals.aim.basis
	rotation_angle = self.get_rotation().y
	
	#Depending on inputs pressed, changes the direction(s) moved to align with the camera's rotation (aim)
	if Input.is_action_pressed("move_forward"):
		Globals.direction += Vector3(-sin(rotation_angle), 0, -cos(rotation_angle))
	if Input.is_action_pressed("move_backward"):
		Globals.direction -= Vector3(-sin(rotation_angle), 0, -cos(rotation_angle))
	if Input.is_action_pressed("move_left"):
		Globals.direction -= Globals.aim.x
	if Input.is_action_pressed("move_right"):
		Globals.direction += Globals.aim.x
	
	#Normalizes direction so that pressing multiple movement keys doesn't move you any faster
	Globals.direction = Globals.direction.normalized()
	
	#Adds gravity effect to the velocity
	Globals.velocity.y += gravity * delta
	
	#Velocity variable used to manipulate non-vertical movement
	var temp_velocity = Globals.velocity
	temp_velocity.y = 0
	
	var speed
	#If sprinting, set max speed to sprint speed, else normal max speed
	if Input.is_action_pressed("move_sprint"):
		speed = max_running_speed
	else:
		speed = max_speed
	
	#Where the player goes at max speed
	var target = Globals.direction * speed
	
	var acceleration
	#If direction and velocity are in the same general direction
	if Globals.direction.dot(temp_velocity) > 0:
		acceleration = accel
	else:
		acceleration = decel
	
	#Calculates the distance to move 
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration*delta)
	
	Globals.velocity.x = temp_velocity.x
	Globals.velocity.z = temp_velocity.z
	
	#Move with the calculated velocity
	Globals.velocity = move_and_slide(Globals.velocity, Vector3(0, 1, 0))
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			Globals.velocity.y = jump_strength

