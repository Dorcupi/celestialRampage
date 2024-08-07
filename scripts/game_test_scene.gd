extends Node2D

@onready var player = $Player

@onready var healthPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var bulletPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var manaPowerPreload = preload("res://assets/powerups/mana_powerup.tscn")

@onready var powerupTimer

@onready var controllerCursor = player.get_node("CursorLayer/ControllerCursor")

var totalEnKilled = 0

var enemiesSpawned = 5

var waveOn = true

var powerupsAvaliable = 0

var gamePaused = false

func _input(event):
	if event.is_action_pressed("debug_key"):
		$DebugScreen.visible = not $DebugScreen.visible

func debugPowerup(posX: int, posY: int):
	randomize()
	var powerupSelection = randi_range(1,6)
	
	if powerupSelection >= 4:
		var loadingPowerup = manaPowerPreload.instantiate()
		loadingPowerup.position.x = posX
		loadingPowerup.position.y = posY
		loadingPowerup.name = "PowerupM" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	elif powerupSelection >= 2:
		var loadingPowerup = bulletPowerPreload.instantiate()
		loadingPowerup.position.x = posX
		loadingPowerup.position.y = posY
		loadingPowerup.name = "PowerupB" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	elif powerupSelection >= 0:
		var loadingPowerup = healthPowerPreload.instantiate()
		loadingPowerup.position.x = posX
		loadingPowerup.position.y = posY
		loadingPowerup.name = "PowerupH" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	else:
		var loadingPowerup = manaPowerPreload.instantiate()
		loadingPowerup.position.x = posX
		loadingPowerup.position.y = posY
		loadingPowerup.name = "PowerupR" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)

func _ready():
	waveOn = true
	enemiesSpawned = 5
	$CanvasLayer/Control/Wave.text = "WAVE 0"
	$CanvasLayer/AnimationPlayer.play("wave_fade_in")
	

func _physics_process(delta):
	
	$DebugScreen/Control/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	$DebugScreen/Control/Arch.text = "Running on " + str(Engine.get_architecture_name())
	
	$Player/Camera2D/CanvasLayer/CRTEffect.visible = GameData.crtShader
	
	$CanvasLayer/Control2/ProgressBar.max_value = player.maxHealth
	
	$CanvasLayer/Control2/ProgressBar.value = lerp($CanvasLayer/Control2/ProgressBar.value, float(player.health), 0.75)
	
	$CanvasLayer/Control2/ManaBar.max_value = player.maxMana
	
	$CanvasLayer/Control2/ManaBar.value = lerp($CanvasLayer/Control2/ManaBar.value, float(player.mana), 0.75)
		
	if Input.is_action_just_pressed("pause"):
		gamePaused = not gamePaused
		get_tree().paused = not get_tree().paused
		
	if get_tree().paused:
		$PauseLayer.visible = true
	else:
		$PauseLayer.visible = false
		
	player.mana = lerp(float(player.mana), float(player.maxMana), 0.0005)
	
	if gamePaused == true:
		controllerCursor.forward_keybind = "joypad_forward"
		controllerCursor.backward_keybind = "joypad_backward"
		controllerCursor.left_keybind = "joypad_left"
		controllerCursor.right_keybind = "joypad_right"
		controllerCursor.click_keybind = "joypad_click_event"
	else:
		controllerCursor.forward_keybind = "joypad_rotate_forward"
		controllerCursor.backward_keybind = "joypad_rotate_backward"
		controllerCursor.left_keybind = "joypad_rotate_left"
		controllerCursor.right_keybind = "joypad_rotate_right"
		controllerCursor.click_keybind = ""


func _on_unpause_button_button_up():
	gamePaused = false
	get_tree().paused = false
		
	if get_tree().paused:
		$PauseLayer.visible = true
	else:
		$PauseLayer.visible = false


func _on_exit_button_button_up():
	gamePaused = false
	get_tree().paused = false
		
	if get_tree().paused:
		$PauseLayer.visible = true
	else:
		$PauseLayer.visible = false
		
	get_tree().change_scene_to_file(GameData.lastScenea)


func _on_insta_death_button_up():
	$DebugScreen.visible = false
	$Player.hit(100)


func _on_powerup_button_up():
	debugPowerup($Player.global_position.x, $Player.global_position.x)
