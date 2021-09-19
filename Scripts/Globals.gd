extends Node

var velocity = 0
var cameraPitch
var direction
var aim
var cameraAim
var rotation_angle = 0
var pauseState = false
var pausable = false
var playerWithFrisbee
var player
var world = null

var frisbeeScene
var frisbee

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	frisbeeScene = preload("res://Scenes/Objects/Frisbee.tscn")
	
	
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseGame()
	
		
		
func giveFrisbee(player):
	player.hasFrisbee = true
	playerWithFrisbee = player

func removeFrisbee(player):
	player.hasFrisbee = false
	playerWithFrisbee = null
	
func throwFrisbee(player):
	frisbee = frisbeeScene.instance()
	world.add_child(frisbee)
#	removeFrisbee(player)
	
	
		
func pauseGame():
	if pausable:
		if pauseState:
			pauseState = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			pauseState = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
