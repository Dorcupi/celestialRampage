class_name Player
extends CharacterBody2D

signal sprite_animation_finished(anim_name)

@export var forward_keybind = "forward"

@export var backward_keybind = "backward"

@export var left_keybind = "left"

@export var right_keybind = "right"

@export var shoot_keybind = "shoot"

@export var dash_keybind = "dash"

@export var speed = 300

@export var maxHealth = 100

@export var maxMana = 100

var input_dir

var shootLevel = 1

var health

var mana

var mouse_position

var attackDamage = 5

var animDirection = 1

var walking = false

var shooting = false

@onready var bullet = preload("res://characters/bullet.tscn")

@onready var sprite = $Sprite

@onready var clonedMa = sprite.get_material().duplicate()

func _ready():
	
	connect("sprite_animation_finished", Callable(self, "_on_current_animation_finished"))
	
	health = maxHealth
	
	mana = maxMana
	
	sprite.set_material(clonedMa)

func dash():
	speed = speed * 3
	$DashTimer.start()
	$Camera2D/CanvasLayer/DashEffect.visible = true

func hit(damage):
	health = health - damage
	if health <= 0:
		get_parent().waveOn = false
		get_parent().get_node("CanvasLayer/Control").visible = false
		$CanvasLayer/Control2.visible = false
		get_parent().get_node("Stars").visible = false
		get_parent().get_node("Noise").visible = false
		for node in get_parent().get_children():
			if node is Enemy:
				node.queue_free()
		for node in get_parent().get_children():
			if node is Bullet:
				node.queue_free()
		$AnimationPlayer.play("death")
	else:
		$Shaker.start()
		$HurtSound.play()
		sprite.get_material().set_shader_parameter('active',true)
		$FlashTimer.start()
		if $CursorLayer/ControllerCursor.mouse_used == false:
			if GameData.controllerRumble:
				for i in Input.get_connected_joypads():
					Input.start_joy_vibration(i, 1, 1, 0.2)


func get_input():
	
	input_dir = Input.get_vector(left_keybind, right_keybind, forward_keybind, backward_keybind)
	velocity = input_dir * speed
		

func _process(delta):
	mouse_position = get_global_mouse_position()
	
	$ShootPositions.look_at(mouse_position)

func _physics_process(delta):
		
	get_input()
	
	if Input.is_action_pressed(right_keybind):
		animDirection = 1
	elif Input.is_action_pressed(left_keybind):
		animDirection = 2
	if Input.is_action_pressed(backward_keybind):
		animDirection = 3
	elif Input.is_action_pressed(forward_keybind):
		animDirection = 4
	
	if Input.is_action_pressed(right_keybind):
		walking = true
	elif Input.is_action_pressed(left_keybind):
		walking = true
	elif Input.is_action_pressed(backward_keybind):
		walking = true
	elif Input.is_action_pressed(forward_keybind):
		walking = true
	else:
		walking = false
	
	if animDirection == 1 and walking == true:
		sprite.play("WALK_RIGHT")
	elif animDirection == 2 and walking == true:
		sprite.play("WALK_LEFT")
	elif animDirection == 3 and walking == true:
		sprite.play("WALK_DOWN")
	elif animDirection == 4 and walking == true:
		sprite.play("WALK_UP")
	elif animDirection == 1 and shooting == false:
		sprite.play("IDLE_RIGHT")
	elif animDirection == 2 and shooting == false:
		sprite.play("IDLE_LEFT")
	elif animDirection == 3 and shooting == false:
		sprite.play("IDLE_DOWN")
	elif animDirection == 4 and shooting == false:
		sprite.play("IDLE_UP")
	
	if Input.is_action_just_pressed(shoot_keybind):
		
		shooting = true
		
		if animDirection == 1:
			sprite.play("SHOOT_RIGHT")
		elif animDirection == 2:
			sprite.play("SHOOT_LEFT")
		elif animDirection == 3:
			sprite.play("SHOOT_DOWN")
		elif animDirection == 4:
			sprite.play("SHOOT_UP")
		
		var b = bullet.instantiate()
		b.start($ShootPositions/ShootPos.global_position, $ShootPositions.rotation, attackDamage, self)
		get_tree().root.add_child(b)
		$ShootSound.play()
		
		if shootLevel >= 2:
			
			var c = bullet.instantiate()
			c.start($ShootPositions/ShootPos2.global_position, $ShootPositions.rotation, attackDamage, self)
			get_tree().root.add_child(c)
			
		if shootLevel >= 3:
			
			var d = bullet.instantiate()
			d.start($ShootPositions/ShootPos3.global_position, $ShootPositions.rotation, attackDamage, self)
			get_tree().root.add_child(d)
		
		if shootLevel >= 4:
			
			var e = bullet.instantiate()
			e.start($ShootPositions/ShootPos4.global_position, $ShootPositions.rotation, attackDamage, self)
			get_tree().root.add_child(e)
			
		if shootLevel >= 5:
			
			var f = bullet.instantiate()
			f.start($ShootPositions/ShootPos5.global_position, $ShootPositions.rotation, attackDamage, self)
			get_tree().root.add_child(f)
			
	if Input.is_action_just_pressed(dash_keybind):
		if mana >= 40:
			mana -= 40
			dash()
	
	move_and_slide()


func _on_flash_timer_timeout():
	sprite.get_material().set_shader_parameter('active',false)


func _on_shoot_power_timer_timeout():
	shootLevel = 1

func _on_dash_timer_timeout():
	speed = 300
	$Camera2D/CanvasLayer/DashEffect.visible = false


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


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_animation_player_animation_started(anim_name):
	if anim_name == "death":
		$DeathShakeTimer.start(1.4)


func _on_death_shake_timer_timeout():
	$Shaker.start()
	get_parent().get_node("TileMap").modulate = Color("ffffff7a")
