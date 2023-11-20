
extends CharacterBody2D

var uses = 4

func _ready():
	randomize()

func _physics_process(delta):
	if uses <= 0:
		queue_free()
	
func powerup(affecting):
	
	affecting.health += randi_range(30, 80)
	
	if affecting.health > affecting.maxHealth:
		affecting.health = affecting.maxHealth
		
	var x = randi_range(-1168, 1740)
	
	var y = randi_range(-519, 946)
	
	self.position.x = x
	
	self.position.y = y
	
	get_parent().get_node("PowerupSound").play()
	
	uses -= 1
