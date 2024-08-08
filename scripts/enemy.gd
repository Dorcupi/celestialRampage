class_name Enemy
extends CharacterBody2D

@export var speed = 200
@export var maxHealth = 50

var health
var player_position

var attack_damage = 5
var anim_direction = 1
var shooting = false
var walking = true
var isPlayer = true

@onready var bullet = preload("res://characters/bullet.tscn")
@onready var nav_agent := $NavigationAgent2D

func _ready():
	health = maxHealth
	connect("sprite_animation_finished", Callable(self, "_on_current_animation_finished"))
	$AnimationPlayer.play("spawn")

func get_player_position():
	for node in get_parent().get_children():
		if node is Player:
			return node.global_position
	return null

func _physics_process(_delta: float) -> void:
	isPlayer = false
	for node in get_parent().get_children():
		if node is Player:
			isPlayer = true
	if isPlayer == false:
		queue_free()
	player_position = get_player_position()
	if player_position:
		var dist = (player_position - global_position).length()
		if dist >= 200:
			nav_agent.target_position = player_position
			var target_position = nav_agent.get_next_path_position()

			if target_position != Vector2.ZERO:
				var direction = (target_position - global_position).normalized()
				velocity = direction * speed
				move_and_slide()

				update_animation(direction)
		else:
			velocity = Vector2.ZERO  # Stop moving if the distance is greater or equal to 300
			move_and_slide()  # Ensure to stop the movement

		$ShootPosition.look_at(player_position)
		update_shooting_state()

func update_animation(direction: Vector2):
	if direction.x > 0:
		anim_direction = 2
	elif direction.x < 0:
		anim_direction = 4
	elif direction.y > 0:
		anim_direction = 3
	elif direction.y < 0:
		anim_direction = 1

	if walking:
		if anim_direction == 1:
			$Sprite.play("WALK_UP")
		elif anim_direction == 2:
			$Sprite.play("WALK_RIGHT")
		elif anim_direction == 3:
			$Sprite.play("WALK_DOWN")
		elif anim_direction == 4:
			$Sprite.play("WALK_LEFT")
	else:
		if anim_direction == 1:
			$Sprite.play("IDLE_UP")
		elif anim_direction == 2:
			$Sprite.play("IDLE_RIGHT")
		elif anim_direction == 3:
			$Sprite.play("IDLE_DOWN")
		elif anim_direction == 4:
			$Sprite.play("IDLE_LEFT")

func update_shooting_state():
	var dist = (player_position - global_position).length()
	if dist <= 300:
		if $ShootTimer.is_stopped():
			if get_parent().waveOn:
				walking = false
				$ShootTimer.start()
		else:
			if get_parent().waveOn:
				walking = false
	else:
		if get_parent().waveOn:
			walking = true
			if !$ShootTimer.is_stopped():
				$ShootTimer.stop()

func _on_shoot_timer_timeout():
	shooting = true
	var b = bullet.instantiate()
	b.start($ShootPosition/ShootPos.global_position, $ShootPosition.rotation, attack_damage, self, 1)
	get_tree().root.add_child(b)
	update_shoot_animation()

func update_shoot_animation():
	if anim_direction == 1:
		$Sprite.play("SHOOT_UP")
	elif anim_direction == 2:
		$Sprite.play("SHOOT_RIGHT")
	elif anim_direction == 3:
		$Sprite.play("SHOOT_DOWN")
	elif anim_direction == 4:
		$Sprite.play("SHOOT_LEFT")

func _on_current_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("SHOOT_"):
		shooting = false

func hit(damage):
	health -= damage
	if health <= 0:
		get_parent().enemiesKilled += 1
		get_parent().totalEnKilled += 1
		get_parent().get_node("DeathSound").play()
		queue_free()
	else:
		$Sprite.get_material().set_shader_parameter('active', true)
		$FlashTimer.start()
		$HurtSound.play()

func _on_flash_timer_timeout():
	$Sprite.get_material().set_shader_parameter('active', false)
