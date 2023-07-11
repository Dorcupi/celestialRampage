extends Node2D

func fullscreenCheck():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$CanvasLayer/Control/VBoxContainer/FullscreenButton.button_pressed = true
	else:
		$CanvasLayer/Control/VBoxContainer/FullscreenButton.button_pressed = false

func _ready():
	$CanvasLayer/Control/VBoxContainer/SpaceBackgroundButton.button_pressed = GameData.spaceBackground
	
	$CanvasLayer/Control/VBoxContainer/CRTEffectButton.button_pressed = GameData.crtShader
	
	fullscreenCheck()
	
	$AnimationPlayer.play("fade_out")

func _physics_process(delta):
	$Noise.visible = GameData.spaceBackground
	$CanvasLayer/CRTEffect.visible = GameData.crtShader
	$CanvasLayer/Control/VBoxContainer/FullscreenButton.button_pressed = GameData.fullscreen
	$CanvasLayer/Control/VBoxContainer/RumbleButton.button_pressed = GameData.controllerRumble

func _on_check_button_toggled(button_pressed):
	
	GameData.spaceBackground = button_pressed

func _on_crt_effect_button_toggled(button_pressed):
	
	GameData.crtShader = button_pressed

func _on_fullscreen_button_toggled(button_pressed):
	
	if button_pressed == false:
		DisplayServer.window_set_mode(GameData.lastMode)
	else:
		GameData.lastMode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	GameData.fullscreen = button_pressed


func _on_rumble_button_toggled(button_pressed):
	GameData.controllerRumble = button_pressed
