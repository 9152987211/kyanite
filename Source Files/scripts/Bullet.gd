extends KinematicBody2D


var velocity = Vector2.ZERO
var dir
var speed = 350
var gun


func _physics_process(delta):
	#MOVE THE BULLET
	velocity.x = dir.x * speed * delta
	velocity.y = dir.y * speed * delta
	var collisionInfo = move_and_collide(velocity)
	
	var damageMultiplier = 1
	if get_parent().get_parent().get_node("Player").damageBuffEnabled == true:
		damageMultiplier = get_parent().get_parent().get_node("Player").damageBuffAmount
	
	#CHECK BULLET COLLISION WITH ENEMIES
	if $Area2D.get_overlapping_areas().size() > 0:
		var n = $Area2D.get_overlapping_areas()[0].get_parent().name
		if n.substr(0, 7) == "@Zombie" or n == "Zombie":
			var p = get_parent().get_parent().get_node("Player")
			var e = get_parent().get_parent().get_node("Enemies").get_node(n)
			if gun == "Smg":
				e.health -= (p.get_node("Smg").damage * damageMultiplier)
				e.takeDamage()
			elif gun == "Pistol":
				e.health -= (p.get_node("Pistol").damage * damageMultiplier)
				e.takeDamage()
			elif gun == "Shotgun":
				e.health -= (p.get_node("Shotgun").damage * damageMultiplier)
				e.takeDamage()
			free()
		elif n.substr(0, 6) == "@Ninja" or n == "Ninja":
			var p = get_parent().get_parent().get_node("Player")
			var e = get_parent().get_parent().get_node("Enemies").get_node(n)
			if gun == "Smg":
				e.health -= (p.get_node("Smg").damage * damageMultiplier)
				e.takeDamage()
			elif gun == "Pistol":
				e.health -= (p.get_node("Pistol").damage * damageMultiplier)
				e.takeDamage()
			elif gun == "Shotgun":
				e.health -= (p.get_node("Shotgun").damage * damageMultiplier)
				e.takeDamage()
			free()
		elif n.substr(0, 8) == "@Vampire" or n == "Vampire":
			var p = get_parent().get_parent().get_node("Player")
			var e = get_parent().get_parent().get_node("Enemies").get_node(n)
			if gun == "Smg":
				e.health -= (p.get_node("Smg").damage * damageMultiplier)
				e.takeDamage()
			elif gun == "Pistol":
				e.health -= (p.get_node("Pistol").damage * damageMultiplier)
				e.takeDamage()
			elif gun == "Shotgun":
				e.health -= (p.get_node("Shotgun").damage * damageMultiplier)
				e.takeDamage()
			free()
		elif n.substr(0, 4) == "@Bat" or n == "Bat":
			var p = get_parent().get_parent().get_node("Player")
			var e = get_parent().get_parent().get_node("Enemies").get_node(n)
			if gun == "Smg":
				e.health -= (p.get_node("Smg").damage * damageMultiplier)
			elif gun == "Pistol":
				e.health -= (p.get_node("Pistol").damage * damageMultiplier)
			elif gun == "Shotgun":
				e.health -= (p.get_node("Shotgun").damage * damageMultiplier)
			free()
