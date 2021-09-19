extends RigidBody

export var initialSpeed = 20
var startYaw
var startAngleOfAttack
var player
var speed
var liftCoefficient
var liftForce
var liftVector
var forwardVector
var velocityDirection
var dragCoefficient
var dragForce
var dragVector
var angleOfAttack
var groundSpeed

func _ready():
	#$Camera.make_current()
	player = Globals.playerWithFrisbee
	startAngleOfAttack = player.pitch
	
	#Positioning and rotating the frisbee
	self.set_translation(player.globalPos)
	self.set_rotation_degrees(Vector3(player.pitch, rad2deg(player.rotation_angle), 0))
	
	#Applying initial speed
	self.apply_central_impulse(Globals.cameraAim*initialSpeed*cos(deg2rad(startAngleOfAttack/sqrt(2))))
	
func _physics_process(delta):
	if not Globals.pauseState:
		#Magnitude of linear velocity
		speed = sqrt(pow(linear_velocity.x,2) + pow(linear_velocity.y,2) + pow(linear_velocity.z,2))
		
		#Ground speed
		groundSpeed = abs(global_transform.basis.xform_inv(linear_velocity).z)
		
		#Vector which dictates up (for lift)
		liftVector = global_transform.basis.y
		
		#Vector which dictates drag 
		dragVector = -linear_velocity
		
		#Forward Vector
		forwardVector = -global_transform.basis.z
		
		#Velocity vector
		velocityDirection = linear_velocity.normalized()
		
		#Calculating angle of attack (RADIANS)
		angleOfAttack = fmod(forwardVector.angle_to(linear_velocity),PI/2)
		
		#Calculating magnitude of the lift
		liftCoefficient = 2*angleOfAttack
		liftForce = delta*pow(speed,2)*liftCoefficient*6
		
		#Calculating drag
		dragCoefficient = 20 + 0.033*pow((rad2deg(angleOfAttack)-startAngleOfAttack),2)
		dragForce = delta*pow(speed,2)*dragCoefficient*0.001
		
		#Adding lift and drag
		self.apply_central_impulse(liftVector*liftForce*delta)
		self.apply_central_impulse(dragVector*dragForce*delta)
	
		
		
		
	
