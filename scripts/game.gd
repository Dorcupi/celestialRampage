extends Node2D

@onready var enemyPreload = preload("res://characters/enemy.tscn")

@onready var player = $Player

var wave = 1

var enemiesRequired = 5

var enemiesKilled = 0

var enemiesSpawned = 5

var waveOn = true

func summon_enemy():
	
	var x = randi_range(-1168, 1740)
	
	var y = randi_range(-519, 946)
	
	var e = enemyPreload.instantiate()
	
	e.position.x = x
	
	e.position.y = y
	
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
	$CanvasLayer/Wave.text = "WAVE " + str(wave)
	$CanvasLayer/AnimationPlayer.play("wave_fade_in")

func _physics_process(delta):
	$CanvasLayer/HealthBarB.size.x = (300 / $Player.maxHealth) * ($Player.health)
	$CanvasLayer/Health.text = str($Player.health) + "/" + str($Player.maxHealth)
	
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
	$CanvasLayer/Wave.text = "WAVE " + str(wave)
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
