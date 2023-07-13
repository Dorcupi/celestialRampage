extends Node2D

@onready var enemyPreload = preload("res://characters/enemy.tscn")

@onready var player = $Player

@onready var healthPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var bulletPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var powerupTimer

@onready var controllerCursor = player.get_node("CursorLayer/ControllerCursor")

# Music

@onready var song1 = preload("res://music/CSRampage_Loop_Song_A.mp3")

@onready var song2 = preload("res://music/CSRampage_Loop_Song_2.mp3")

var songPlaying = 1

var songAmount = 2

var wave = 1

var enemiesRequired = 5

var enemiesKilled = 0

var totalEnKilled = 0

var enemiesSpawned = 5

var waveOn = true

var powerupsAvaliable = 0

var gamePaused = false

func reroll_song():
	var newSong = randi_range(1, songAmount)
	if newSong == songPlaying:
		return(reroll_song())
	else:
		return(newSong)

func play_song():
	var songChoice = reroll_song()
	if songChoice == 1:
		$BackgroundMusic.stream = song1
	elif songChoice == 2:
		$BackgroundMusic.stream = song2
	else:
		$BackgroundMusic.stream = song2
	$BackgroundMusic.play()

func checkForPowerups():
	powerupsAvaliable = 0
	for child in get_children(false):
		if child is Powerup:
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
	
	$Noise.visible = GameData.spaceBackground
	
	$Player/Camera2D/CanvasLayer/CRTEffect.visible = GameData.crtShader
	
	$CanvasLayer/Control2/ProgressBar.max_value = player.maxHealth
	
	$CanvasLayer/Control2/ProgressBar.value = player.health
	
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
		var powerupSelection = randi_range(1,3)
		
		if powerupSelection >= 2:
			var loadingPowerup = bulletPowerPreload.instantiate()
			loadingPowerup.position.x = randi_range(-1168, 1740)
			loadingPowerup.position.y = randi_range(-519, 946)
			loadingPowerup.name = "PowerupB" + str(powerupsAvaliable + 1)
			add_child(loadingPowerup)
		
		if powerupSelection >= 1:
			var loadingPowerup = healthPowerPreload.instantiate()
			loadingPowerup.position.x = randi_range(-1168, 1740)
			loadingPowerup.position.y = randi_range(-519, 946)
			loadingPowerup.name = "PowerupH" + str(powerupsAvaliable + 1)
			add_child(loadingPowerup)


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
