extends KinematicBody2D


var velocity = Vector2.ZERO
var dir = Vector2.ZERO
var damage = 0
var speed = 100


func _physics_process(delta):
	#MOVE THE SHURIKEN
	velocity.x = dir.x * speed * delta
	velocity.y = dir.y * speed * delta
	var collisionInfo = move_and_collide(velocity)
	
	
	#CHECK COLLISIONS BETWEEN PLAYER AND SHURIKEN
	if $Area2D.get_overlapping_areas().size() > 0:
		var n = $Area2D.get_overlapping_areas()[0].get_parent().name
		var w = get_parent().get_parent()
		if n.substr(0, 8) == "@Player" or n == "Player":
			w.get_node("Player").takeDamage(damage)
			free()
