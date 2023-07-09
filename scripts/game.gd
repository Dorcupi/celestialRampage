extends Node2D

@onready var enemyPreload = preload("res://characters/enemy.tscn")

@onready var player = $Player

@onready var healthPowerPreload = preload("res://assets/powerups/health_powerup.tscn")

@onready var powerupTimer

var wave = 1

var enemiesRequired = 5

var enemiesKilled = 0

var enemiesSpawned = 5

var waveOn = true

var powerupsAvaliable = 0

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
	randomize()
	summon_enemies(5)
	waveOn = true
	enemiesKilled = 0
	enemiesRequired = 5
	enemiesSpawned = 5
	$CanvasLayer/Control/Wave.text = "WAVE " + str(wave)
	$CanvasLayer/AnimationPlayer.play("wave_fade_in")

func _physics_process(delta):
	$CanvasLayer/Control2/HealthBarB.size.x = (300 / $Player.maxHealth) * ($Player.health)
	$CanvasLayer/Control2/Health.text = str($Player.health) + "/" + str($Player.maxHealth)
	
	if enemiesKilled == enemiesRequired and waveOn:
		waveOn = false
		enemiesKilled = 0
		enemiesSpawned = 0
		enemiesRequired += randi_range(2, 5)
		player.maxHealth += randi_range(20, 50)
		player.health += randi_range(5, 15)
		$SpawnTimer.stop()
		$CooldownTimer.start(5)


func _on_cooldown_timer_timeout():
	wave += 1
	$CanvasLayer/Control/Wave.text = "WAVE " + str(wave)
	$CanvasLayer/AnimationPlayer.play("wave_fade_in")
	waveOn = true
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
		var powerupSelection = randi_range(1,1)
		if powerupSelection == 1:
			var loadingPowerup = healthPowerPreload.instantiate()
			loadingPowerup.position.x = randi_range(-1168, 1740)
			loadingPowerup.position.y = randi_range(-519, 946)
			loadingPowerup.name = "PowerupH" + str(powerupsAvaliable + 1)
			add_child(loadingPowerup)
