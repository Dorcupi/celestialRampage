class_name Enemy
extends CharacterBody2D

signal sprite_animation_finished(anim_name)

@export var speed = 500

@export var maxHealth = 50

var health

var playerPosition

var attackDamage = 5

var animDirection = 1

var shooting = false

var walking = true

@onready var bullet = preload("res://characters/bullet.tscn")

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	health = maxHealth
	connect("sprite_animation_finished", Callable(self, "_on_current_animation_finished"))
	$AnimationPlayer.play("spawn")

func get_player_position():
	for node in get_parent().get_children():
		if node is Player:
			return node.global_position

func in_range(num: int, start: int, end: int) -> int: # Checks if a number is in the provided range
	return (num >= start && num < end)

func _physics_process(_delta: float) -> void:
	
	playerPosition = get_player_position()
	
	$ShootPosition.look_at(playerPosition)
	
	if in_range($ShootPosition.rotation_degrees, 0, 90):
		animDirection = 2
	elif in_range($ShootPosition.rotation_degrees, 91, 180):
		animDirection = 3
	elif in_range($ShootPosition.rotation_degrees, 181, 270):
		animDirection = 4
	elif in_range($ShootPosition.rotation_degrees, 271, 359):
		animDirection = 1
	elif $ShootPosition.rotation_degrees == 360:
		animDirection = 2
	elif in_range($ShootPosition.rotation_degrees, -90, 0):
		animDirection = 1
	elif in_range($ShootPosition.rotation_degrees, -180, -91):
		animDirection = 4
	elif in_range($ShootPosition.rotation_degrees, -270, -181):
		animDirection = 3
	elif in_range($ShootPosition.rotation_degrees, -359, -271):
		animDirection = 2
	else:
		animDirection = 2
	
	var dist = playerPosition - global_position
	
	var newVol: Vector2 = nav_agent.get_next_path_position() - global_position
	
	newVol = newVol / 8
	
	newVol = newVol.normalized()
	
	newVol = newVol * speed
	
	velocity = newVol
			
	if dist.length() <= 300: # If distance is less or equal to 300px
		if $ShootTimer.is_stopped(): # if shoot time is stopped
			if get_parent().waveOn:
				walking = false
				$ShootTimer.start() # start timer
		else:
			if get_parent().waveOn:
				walking = false
	else: # if distance isn't
		if get_parent().waveOn:
			walking = true
			move_and_slide()
			if $ShootTimer.is_stopped() != true:
				$ShootTimer.stop()
			
	if animDirection == 1 and walking == true:
		$Sprite.play("WALK_UP")
	elif animDirection == 2 and walking == true:
		$Sprite.play("WALK_RIGHT")
	elif animDirection == 3 and walking == true:
		$Sprite.play("WALK_DOWN")
	elif animDirection == 4 and walking == true:
		$Sprite.play("WALK_LEFT")
	if animDirection == 1 and shooting == false:
		$Sprite.play("IDLE_UP")
	elif animDirection == 2 and shooting == false:
		$Sprite.play("IDLE_RIGHT")
	elif animDirection == 3 and shooting == false:
		$Sprite.play("IDLE_DOWN")
	elif animDirection == 4 and shooting == false:
		$Sprite.play("IDLE_LEFT")

func hit(damage):
	health = health - damage
	if health <= 0:
		get_parent().enemiesKilled += 1
		get_parent().totalEnKilled += 1
		get_parent().get_node("DeathSound").play()
		queue_free()
	else:
		$Sprite.get_material().set_shader_parameter('active',true)
		$FlashTimer.start()
		$HurtSound.play()


func _on_shoot_timer_timeout():
	shooting = true
	var b = bullet.instantiate()
	b.start($ShootPosition/ShootPos.global_position, $ShootPosition.rotation, attackDamage, self)
	get_tree().root.add_child(b)
	if animDirection == 1:
		$Sprite.play("SHOOT_UP")
	elif animDirection == 2:
		$Sprite.play("SHOOT_RIGHT")
	elif animDirection == 3:
		$Sprite.play("SHOOT_DOWN")
	elif animDirection == 4:
		$Sprite.play("SHOOT_LEFT")


func _on_flash_timer_timeout():
	$Sprite.get_material().set_shader_parameter('active',false)


func _on_sprite_animation_finished():
	emit_signal("sprite_animation_finished", $Sprite.animation)
	
func _on_current_animation_finished(anim_name: String) -> void:
	if anim_name == "SHOOT_UP":
		shooting = false
	elif anim_name == "SHOOT_DOWN":
		shooting = false
	elif anim_name == "SHOOT_LEFT":
		shooting = false
	elif anim_name == "SHOOT_RIGHT":
		shooting = false

func _on_ai_timer_timeout() -> void:
	nav_agent.target_position = playerPosition
