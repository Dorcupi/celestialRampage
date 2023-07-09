class_name Player
extends CharacterBody2D

@export var forward_keybind = "forward"

@export var backward_keybind = "backward"

@export var left_keybind = "left"

@export var right_keybind = "right"

@export var shoot_keybind = "shoot"

@export var speed = 300

@export var maxHealth = 100

var health

var mouse_position

var attackDamage = 5

@onready var bullet = preload("res://characters/bullet.tscn")

func _ready():
	health = maxHealth

func hit(damage):
	health = health - damage
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		$Shaker.start()

func get_input():
	var input_dir = Input.get_vector(left_keybind, right_keybind, forward_keybind, backward_keybind)
	velocity = input_dir * speed

func _physics_process(delta):
	
	mouse_position = get_global_mouse_position()
	
	look_at(mouse_position)
	
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
	
	move_and_slide()
