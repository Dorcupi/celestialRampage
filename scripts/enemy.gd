class_name Enemy
extends CharacterBody2D

@export var speed = 300

@export var maxHealth = 50

var health

var playerPosition

var attackDamage = 5

@onready var bullet = preload("res://characters/bullet.tscn")

func _ready():
	health = maxHealth

func get_player_position():
	for node in get_parent().get_children():
		if node is Player:
			return node.global_position
			break

func _physics_process(delta):
	
	playerPosition = get_player_position()
	
	look_at(playerPosition)
	
	if global_rotation >= 3:
		$CPUParticles2D.gravity.x = 980
		$CPUParticles2D.gravity.y = 0
	elif global_rotation >= 1.99:
		$CPUParticles2D.gravity.x = 0
		$CPUParticles2D.gravity.y = -980
	elif global_rotation >= 0.99:
		$CPUParticles2D.gravity.x = 0
		$CPUParticles2D.gravity.y = -980
	elif global_rotation >= -0:
		$CPUParticles2D.gravity.x = -980
		$CPUParticles2D.gravity.y = 0
	elif global_rotation >= -1:
		$CPUParticles2D.gravity.x = -980
		$CPUParticles2D.gravity.y = 0
	elif global_rotation >= -2:
		$CPUParticles2D.gravity.x = 0
		$CPUParticles2D.gravity.y = 980
	elif global_rotation >= -3.99:
		$CPUParticles2D.gravity.x = 980
		$CPUParticles2D.gravity.y = 0
	else:
		$CPUParticles2D.gravity.x = 0
		$CPUParticles2D.gravity.y = 980
	
	velocity = Vector2(speed, 0).rotated(rotation)
	
	var dir = playerPosition - global_position
	
	if dir.length() > 500 and get_parent().waveOn:
		move_and_slide()
			
	if dir.length() > 510:
		if $ShootTimer.is_stopped():
			pass
		else:
			$ShootTimer.stop()
	else:
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
	
func hit(damage):
	health = health - damage
	if health <= 0:
		get_parent().enemiesKilled += 1
		get_parent().totalEnKilled += 1
		get_parent().get_node("DeathSound").play()
		queue_free()
	else:
		$Polygon2D.get_material().set_shader_parameter('active',true)
		$FlashTimer.start()
		$HurtSound.play()


func _on_shoot_timer_timeout():
	var b = bullet.instantiate()
	b.start($ShootPos.global_position, rotation, attackDamage, self)
	get_tree().root.add_child(b)


func _on_flash_timer_timeout():
	$Polygon2D.get_material().set_shader_parameter('active',false)
