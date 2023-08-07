extends Node2D

@onready var enemyPreload = preload("res://characters/enemy.tscn")

@onready var player = $Player

@onready var healthPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var bulletPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var manaPowerPreload = preload("res://assets/powerups/mana_powerup.tscn")

@onready var powerupTimer

@onready var controllerCursor = player.get_node("CursorLayer/ControllerCursor")

# Music

@onready var song1 = preload("res://music/CSRampage_Loop_Song_A.mp3")

@onready var song2 = preload("res://music/CSRampage_Loop_Song_2.mp3")

@onready var song3 = preload("res://music/CSRampage_Loop_Song_3.mp3")

@onready var song4 = preload("res://music/CSRampage_Loop_Mix_1_2.mp3")

var songPlaying = 1

var songAmount = 4

var wave = 1

var enemiesRequired = 5

var enemiesKilled = 0

var totalEnKilled = 0

var enemiesSpawned = 5

var waveOn = true

var powerupsAvaliable = 0

var gamePaused = false

func _input(event):
	if event.is_action_pressed("debug_key"):
		$DebugScreen.visible = not $DebugScreen.visible

func spawnPowerup():
	randomize()
	var powerupSelection = randi_range(0,7)
	
	if powerupSelection <= 5:
		var loadingPowerup = manaPowerPreload.instantiate()
		loadingPowerup.position.x = randi_range(-1168, 1740)
		loadingPowerup.position.y = randi_range(-519, 946)
		loadingPowerup.name = "PowerupM" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	elif powerupSelection <= 3:
		var loadingPowerup = bulletPowerPreload.instantiate()
		loadingPowerup.position.x = randi_range(-1168, 1740)
		loadingPowerup.position.y = randi_range(-519, 946)
		loadingPowerup.name = "PowerupB" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	elif powerupSelection <= 1:
		var loadingPowerup = healthPowerPreload.instantiate()
		loadingPowerup.position.x = randi_range(-1168, 1740)
		loadingPowerup.position.y = randi_range(-519, 946)
		loadingPowerup.name = "PowerupH" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	else:
		var loadingPowerup = manaPowerPreload.instantiate()
		loadingPowerup.position.x = randi_range(-1168, 1740)
		loadingPowerup.position.y = randi_range(-519, 946)
		loadingPowerup.name = "PowerupR" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)

func debugPowerup(posX: int, posY: int):
	randomize()
	var powerupSelection = randi_range(1,6)
	
	if powerupSelection <= 5:
		var loadingPowerup = manaPowerPreload.instantiate()
		loadingPowerup.position.x = posX
		loadingPowerup.position.y = posY
		loadingPowerup.name = "PowerupM" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	elif powerupSelection <= 3:
		var loadingPowerup = bulletPowerPreload.instantiate()
		loadingPowerup.position.x = posX
		loadingPowerup.position.y = posY
		loadingPowerup.name = "PowerupB" + str(powerupsAvaliable + 1)
		add_child(loadingPowerup)
	elif powerupSelection <= 1:
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

func reroll_song():
	randomize()
	var newSong = randi_range(1, songAmount)
	if newSong == songPlaying:
		return(reroll_song())
	else:
		return(newSong)

func play_song():
	randomize()
	var songChoice = reroll_song()
	if songChoice == 1:
		$BackgroundMusic.stream = song1
	elif songChoice == 2:
		$BackgroundMusic.stream = song2
	elif songChoice == 3:
		$BackgroundMusic.stream = song3
	elif songChoice == 4:
		$BackgroundMusic.stream = song4
	else:
		$BackgroundMusic.stream = song4
	$BackgroundMusic.play()

func checkForPowerups():
	powerupsAvaliable = 0
	for child in get_children(false):
		if child.is_in_group("powerup"):
			powerupsAvaliable += 1

func summon_enemy():
	
	var x = randi_range(-1168, 1740)
	
	var y = randi_range(-519, 946)
	
	var e = enemyPreload.instantiate()
	
	e.position.x = x
	
	e.position.y = y
	
	var clonedMa = e.get_node("Polygon2D").get_material().duplicate()
	
	e.get_node("Polygon2D").set_material(clonedMa)
	
	add_child(e)
	
	print("SUCCESS")

func summon_enemies(enemyAmount):
	for i in range(enemyAmount):
		summon_enemy()

func _ready():
	$MusicTimer.start(2)
	randomize()
	summon_enemies(5)
	waveOn = true
	enemiesKilled = 0
	enemiesRequired = 5
	enemiesSpawned = 5
	$CanvasLayer/Control/Wave.text = "WAVE " + str(wave)
	$CanvasLayer/AnimationPlayer.play("wave_fade_in")
	

func _physics_process(delta):
	
	$DebugScreen/Control/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	$Noise.visible = GameData.spaceBackground
	
	$Player/Camera2D/CanvasLayer/CRTEffect.visible = GameData.crtShader
	
	$CanvasLayer/Control2/ProgressBar.max_value = player.maxHealth
	
	$CanvasLayer/Control2/ProgressBar.value = lerp($CanvasLayer/Control2/ProgressBar.value, float(player.health), 0.75)
	
	$CanvasLayer/Control2/ManaBar.max_value = player.maxMana
	
	$CanvasLayer/Control2/ManaBar.value = lerp($CanvasLayer/Control2/ManaBar.value, float(player.mana), 0.75)
	
	if enemiesKilled == enemiesRequired and waveOn:
		waveOn = false
		enemiesKilled = 0
		enemiesSpawned = 0
		enemiesRequired += randi_range(2, 5)
		$SpawnTimer.stop()
		$CooldownTimer.start(5)
		
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
		print(controllerCursor.click_keybind)
	else:
		controllerCursor.forward_keybind = "joypad_rotate_forward"
		controllerCursor.backward_keybind = "joypad_rotate_backward"
		controllerCursor.left_keybind = "joypad_rotate_left"
		controllerCursor.right_keybind = "joypad_rotate_right"
		controllerCursor.click_keybind = ""
		print(controllerCursor.click_keybind)


func _on_cooldown_timer_timeout():
	wave += 1
	$CanvasLayer/Control/Wave.text = "WAVE " + str(wave)
	$CanvasLayer/AnimationPlayer.play("wave_fade_in")
	waveOn = true
	player.maxHealth += randi_range(20, 50)
	player.health += randi_range(5, 15)
	summon_enemies(1)
	$SpawnTimer.start()
	enemiesSpawned += 1


func _on_spawn_timer_timeout():
	summon_enemies(1)
	enemiesSpawned += 1
	if enemiesSpawned == enemiesRequired:
		$SpawnTimer.stop()


func _on_powerup_timer_timeout():
	checkForPowerups()
	if powerupsAvaliable <= 2:
		spawnPowerup()


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
		
	get_tree().change_scene_to_file(GameData.lastScene)


func _on_background_music_finished():
	$MusicTimer.start(2)


func _on_music_timer_timeout():
	play_song()
