extends Node2D

var sceneChangePlace

var forward = true

var scenePath = "res://scenes/menu.tscn"


func _ready():
	$AnimationPlayer.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_button_button_up():
	sceneChangePlace = "res://scenes/settings.tscn"
	GameData.lastScene = scenePath
	forward = true
	$PortalSound.play()
	$AnimationPlayer.play("zoom_in")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "zoom_in":
		if forward == true:
			if sceneChangePlace:
				get_tree().change_scene_to_file(sceneChangePlace)


func _on_play_button_button_up():
	sceneChangePlace = "res://scenes/game.tscn"
	GameData.lastScene = scenePath
	forward = true
	$PortalSound.play()
	$AnimationPlayer.play("zoom_in")


func _on_exit_button_button_up():
	GameData.exit()
