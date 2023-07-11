extends Node2D

var sceneChangePlace

var forward = true

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_button_button_up():
	sceneChangePlace = "res://scenes/settings.tscn"
	forward = true
	$AnimationPlayer.play("zoom_in")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "zoom_in":
		if forward == true:
			if sceneChangePlace:
				get_tree().change_scene_to_file(sceneChangePlace)


func _on_play_button_button_up():
	sceneChangePlace = "res://scenes/game.tscn"
	forward = true
	$AnimationPlayer.play("zoom_in")
