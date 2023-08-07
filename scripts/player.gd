class_name Player
extends CharacterBody2D

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

@onready var bullet = preload("res://characters/bullet.tscn")

func _ready():
	health = maxHealth
	
	mana = maxMana
	
	var clonedMa =$Polygon2D.get_material().duplicate()
	
	$Polygon2D.set_material(clonedMa)

func dash():
	speed = speed * 3
	$DashTimer.start()
	$Camera2D/CanvasLayer/DashEffect.visible = true

func hit(damage):
	health = health - damage
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		$Shaker.start()
		$HurtSound.play()
		$Polygon2D.get_material().set_shader_parameter('active',true)
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
	
	look_at(mouse_position)

func _physics_process(delta):
		
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
	
	get_input()
	
	if Input.is_action_just_pressed(shoot_keybind):
		
		var b = bullet.instantiate()
		b.start($ShootPos.global_position, rotation, attackDamage, self)
		get_tree().root.add_child(b)
		$ShootSound.play()
		
		if shootLevel >= 2:
			
			var c = bullet.instantiate()
			c.start($ShootPos2.global_position, rotation, attackDamage, self)
			get_tree().root.add_child(c)
			
		if shootLevel >= 3:
			
			var d = bullet.instantiate()
			d.start($ShootPos3.global_position, rotation, attackDamage, self)
			get_tree().root.add_child(d)
		
		if shootLevel >= 4:
			
			var e = bullet.instantiate()
			e.start($ShootPos4.global_position, rotation, attackDamage, self)
			get_tree().root.add_child(e)
			
		if shootLevel >= 5:
			
			var f = bullet.instantiate()
			f.start($ShootPos5.global_position, rotation, attackDamage, self)
			get_tree().root.add_child(f)
			
	if Input.is_action_just_pressed(dash_keybind):
		if mana >= 40:
			mana -= 40
			dash()
	
	move_and_slide()


func _on_flash_timer_timeout():
	$Polygon2D.get_material().set_shader_parameter('active',false)


func _on_shoot_power_timer_timeout():
	shootLevel = 1

func _on_dash_timer_timeout():
	speed = 300
	$Camera2D/CanvasLayer/DashEffect.visible = false
