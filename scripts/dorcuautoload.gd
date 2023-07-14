extends Node

@onready var sfx_id = AudioServer.get_bus_index("SFX")

@onready var music_id = AudioServer.get_bus_index("Music")

var spaceBackground = true

var crtShader = true

var fullscreen = false

var controllerRumble = true

var lastMode

var lastScene = "res://scenes/menu.tscn"

var musicVolume = 1

var sfxVolume = 1

func _ready():
	lastMode = DisplayServer.window_get_mode()

func _physics_process(delta):
	
	AudioServer.set_bus_volume_db(sfx_id, linear_to_db(sfxVolume))
	AudioServer.set_bus_mute(sfx_id, sfxVolume < 0.05)
	
	AudioServer.set_bus_volume_db(music_id, linear_to_db(musicVolume))
	AudioServer.set_bus_mute(music_id, musicVolume < 0.05)
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen = true
	else:
		fullscreen = false
	
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
