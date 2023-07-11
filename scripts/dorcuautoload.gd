extends Node

var spaceBackground = true

var crtShader = true

var fullscreen = false

var controllerRumble = true

var lastMode

var lastScene

func _ready():
	lastMode = DisplayServer.window_get_mode()

func _physics_process(delta):
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen = true
	else:
		fullscreen = false
	
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
