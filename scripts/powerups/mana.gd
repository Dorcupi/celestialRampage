
extends CharacterBody2D

var uses = 2

func _ready():
	randomize()

func _physics_process(delta):
	if uses <= 0:
		queue_free()
	
func powerup(affecting):
	
	if "mana" in affecting:
		affecting.mana += 50
	
		if affecting.mana > affecting.maxMana:
			affecting.mana = affecting.maxMana
		
	var x = randi_range(-1168, 1740)
	
	var y = randi_range(-519, 946)
	
	self.position.x = x
	
	self.position.y = y
	
	get_parent().get_node("PowerupSound").play()
	
	uses -= 1
