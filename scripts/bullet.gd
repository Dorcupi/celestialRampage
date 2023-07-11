class_name Bullet
extends CharacterBody2D

var speed = 750

var damage = 0

var shooter

func start(_position, _direction, damageAmount, shootPerson):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)
	damage = damageAmount
	shooter = shootPerson
	

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage)
		if collision.get_collider().has_method("powerup"):
			collision.get_collider().powerup(shooter)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	visible = false
