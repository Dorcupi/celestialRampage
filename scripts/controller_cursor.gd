class_name Cursor
extends CharacterBody2D

@export var forward_keybind = "joypad_rotate_forward"

@export var backward_keybind = "joypad_rotate_backward"

@export var left_keybind = "joypad_rotate_left"

@export var right_keybind = "joypad_rotate_right"

@export var click_keybind: String

var mouse_used = true

var evt := InputEventMouseButton.new()

var canMouseClick = true

var canMouseRelease = false

func _input(event):
	if event is InputEventMouseMotion and event.relative or event is InputEventKey:
		mouse_used = true
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		mouse_used = false
		
	if Input.is_action_pressed(click_keybind):
		if canMouseClick == true:
			canMouseClick = false
			canMouseRelease = true
			evt.button_index = MOUSE_BUTTON_LEFT
			evt.position = get_global_position()
			evt.pressed = true
			Input.parse_input_event(evt)
		
	if Input.is_action_just_released(click_keybind):
		if canMouseRelease == true:
			canMouseRelease = false
			evt.button_index = MOUSE_BUTTON_LEFT
			evt.position = get_global_position()
			evt.pressed = false
			Input.parse_input_event(evt)
			canMouseClick = true

func _process(delta):
	
	var inputDir = Input.get_vector(left_keybind, right_keybind, forward_keybind, backward_keybind)
	
	velocity = inputDir * 300
	
	move_and_slide()
	
	if mouse_used == true:
		pass
	else:
		Input.warp_mouse(global_position)

