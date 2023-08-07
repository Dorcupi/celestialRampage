extends Node

@onready var sfx_id = AudioServer.get_bus_index("SFX")

@onready var music_id = AudioServer.get_bus_index("Music")

var gameLoaded = false

var spaceBackground = true

var crtShader = true

var fullscreen = false

var controllerRumble = true

var lastMode

var lastScene = "res://scenes/menu.tscn"

var musicVolume = 1

var sfxVolume = 1

func save():
	var save_game = FileAccess.open("user://settings.save", FileAccess.WRITE)
	var settingsData = {
		"spaceBackground" : spaceBackground,
		"crtShader" : crtShader,
		"fullscreen" : fullscreen,
		"controllerRumble" : controllerRumble,
		"musicVolume" : musicVolume,
		"sfxVolume" : sfxVolume,
		"lastMode" : lastMode
	}
	var json_string = JSON.stringify(settingsData)
	
	save_game.store_line(json_string)
	
	print("SAVED")
	
func load_game():
	if not FileAccess.file_exists("user://settings.save"):
		return # Error! We don't have a save to load.

	var save_game = FileAccess.open("user://settings.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()
		
		if node_data.has("spaceBackground"):
			spaceBackground = node_data["spaceBackground"]
		if node_data.has("crtShader"):
			crtShader = node_data["crtShader"]
		if node_data.has("fullscreen"):
			fullscreen = node_data["fullscreen"]
		else:
			fullscreen = false
		if node_data.has("controllerRumble"):
			controllerRumble = node_data["controllerRumble"]
		if node_data.has("musicVolume"):
			musicVolume = node_data["musicVolume"]
		if node_data.has("sfxVolume"):
			sfxVolume = node_data["sfxVolume"]
		if node_data.has("lastMode"):
			lastMode = node_data["lastMode"]
		else:
			lastMode = DisplayServer.WINDOW_MODE_WINDOWED
		
		if fullscreen == true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(lastMode)

func fullscreen_toggle(button_pressed):
	
	fullscreen = button_pressed
	
	if button_pressed == false:
		DisplayServer.window_set_mode(lastMode)
	else:
		lastMode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func onLoad():
	await load_game()
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(lastMode)
	get_tree().set_auto_accept_quit(false)
	gameLoaded = true

func onExit():
	save()

func exit():
	await onExit()
	get_tree().quit()

func _notification(notif):
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		exit()

func _ready():
	pass

func _physics_process(delta):
	
	if gameLoaded == false:
		onLoad()
	
	AudioServer.set_bus_volume_db(sfx_id, linear_to_db(sfxVolume))
	AudioServer.set_bus_mute(sfx_id, sfxVolume < 0.05)
	
	AudioServer.set_bus_volume_db(music_id, linear_to_db(musicVolume))
	AudioServer.set_bus_mute(music_id, musicVolume < 0.05)
	
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
