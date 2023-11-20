extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("splash")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "splash":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
