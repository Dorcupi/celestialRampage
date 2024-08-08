extends Node2D

var fadeForwards = true

func _ready():
	
	$CanvasLayer/Control/VBoxContainer/SpaceBackgroundButton.button_pressed = GameData.spaceBackground
	
	$CanvasLayer/Control/VBoxContainer/CRTEffectButton.button_pressed = GameData.crtShader
	
	$CanvasLayer/Control/VBoxContainer/FullscreenButton.button_pressed = GameData.fullscreen
	
	fadeForwards = true
	
	$AnimationPlayer.play("fade_out")

func _physics_process(delta):
	$Noise.visible = GameData.spaceBackground
	$CanvasLayer/CRTEffect.visible = GameData.crtShader
	$CanvasLayer/Control/VBoxContainer/RumbleButton.button_pressed = GameData.controllerRumble
	$CanvasLayer/Control/VBoxContainer/MusicSlider/MusicSlider.value = GameData.musicVolume
	$CanvasLayer/Control/VBoxContainer/SFXSlider/SFXSlider.value = GameData.sfxVolume

func _on_check_button_toggled(toggled_on):
	
	GameData.spaceBackground = toggled_on

func _on_crt_effect_button_toggled(toggled_on):
	
	GameData.crtShader = toggled_on

func _on_fullscreen_button_toggled(toggled_on):
	
	await GameData.fullscreen_toggle(toggled_on)

func _on_rumble_button_toggled(toggled_on):
	GameData.controllerRumble = toggled_on


func _on_exit_button_up():
	fadeForwards = false
	await GameData.save()
	$AnimationPlayer.play_backwards("fade_out")


func _on_animation_player_animation_finished(anim_name):
	if fadeForwards == false:
		get_tree().change_scene_to_file(GameData.lastScene)

func _on_music_slider_value_changed(value):
	GameData.musicVolume = value


func _on_sfx_slider_value_changed(value):
	GameData.sfxVolume = value
