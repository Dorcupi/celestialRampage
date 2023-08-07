
extends CharacterBody2D

var uses = 2

func _ready():
	randomize()

func _physics_process(delta):
	if uses <= 0:
		queue_free()
	
func powerup(affecting):
	
	affecting.shootLevel += 1
	
	if affecting.shootLevel > 5:
		affecting.shootLevel = 5
		
	var x = randi_range(-1168, 1740)
	
	var y = randi_range(-519, 946)
	
	self.position.x = x
	
	self.position.y = y
	
	get_parent().get_node("PowerupSound").play()
	
	affecting.get_node("ShootPowerTimer").start()
	
	uses -= 1


func _on_visible_on_screen_notifier_2d_screen_entered():
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	visible = false
