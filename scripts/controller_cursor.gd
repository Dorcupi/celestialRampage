class_name Cursor
extends CharacterBody2D

@export var forward_keybind = "joypad_rotate_forward"

@export var backward_keybind = "joypad_rotate_backward"

@export var left_keybind = "joypad_rotate_left"

@export var right_keybind = "joypad_rotate_right"

@export var click_keybind: String

var mouse_used = true

var mouse_click = InputEventAction.new()

func _ready():
	mouse_click.action = "InputEventMouseButton"
	mouse_click.pressed = true

func _input(event):
	if event is InputEventMouseMotion and event.relative or event is InputEventKey:
		mouse_used = true
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		mouse_used = false
		
	if Input.is_action_just_pressed(click_keybind):
		Input.parse_input_event(mouse_click)
		mouse_click.pressed = false
		Input.parse_input_event(mouse_click)

func _physics_process(delta):
	
	var inputDir = Input.get_vector(left_keybind, right_keybind, forward_keybind, backward_keybind)
	
	velocity = inputDir * 300
	
	move_and_slide()
	
	if mouse_used == true:
		pass
	else:
		Input.warp_mouse(global_position)
