extends KinematicBody2D


var health = 30
var damagedStart = 0
var damaged = false
var damagedLength = 500
var speed = 20
var rng = RandomNumberGenerator.new()
var directionChanged = 0
var shurikenDamage = 3


func _physics_process(delta):
	rng.randomize()
	
	
	#MOVEMENT
	#to be added
	
	#SHOOTING
	if rng.randf() < 0.01 and not get_parent().get_parent().get_node("Player").freezeEnabled:
		var scene = load("res://scenes/Shuriken.tscn")
		var s = scene.instance()
		var player = get_parent().get_parent().get_node("Player")
		var d = Vector2(player.position.x - position.x, player.position.y - position.y)
		s.dir = d.normalized()
		s.position.x = position.x
		s.position.y = position.y
		s.damage = shurikenDamage
		get_parent().get_parent().get_node("Bullets").add_child(s)
	
	
	#DEATH
	if health <= 0:
		get_parent().get_parent().get_node("Player").numberOfKills += 1
		queue_free()
	
	
	#APPLY DAMAGED ANIMATION
	if damaged == true:
		var ratio = float(OS.get_ticks_msec() - damagedStart) / damagedLength
		if ratio > 1:
			ratio = 1
		$Damaged.visible = true
		$Damaged.modulate = Color(1, 1, 1, 1-ratio)
		#END DAMAGE ANIMATION
		if OS.get_ticks_msec() >= damagedStart + damagedLength:
			damaged = false
			$Damaged.visible = false
	
	
	#APPLY FROZEN SPRITE
	if get_parent().get_parent().get_node("Player").freezeEnabled:
		$Frozen.visible = true
	else:
		$Frozen.visible = false


func takeDamage():
	damaged = true
	damagedStart = OS.get_ticks_msec()
