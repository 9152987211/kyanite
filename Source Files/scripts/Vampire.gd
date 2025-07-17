extends KinematicBody2D


var health = 150
var batForm = false
var damagedStart = 0
var damaged = false
var damagedLength = 500
var speed = 50
var rng = RandomNumberGenerator.new()


func _physics_process(delta):
	rng.randomize()
	
	
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
	
	
	#SPAWN BATS
	if rng.randf() < 0.02 and not get_parent().get_parent().get_node("Player").freezeEnabled:
		var scene = load("res://scenes/Bat.tscn")
		var bat = scene.instance()
		bat.position.x = position.x
		bat.position.y = position.y
		get_parent().add_child(bat)
	
	
	if get_parent().get_parent().get_node("Player").freezeEnabled:
		$Frozen.visible = true
	else:
		$Frozen.visible = false


func takeDamage():
	damaged = true
	damagedStart = OS.get_ticks_msec()
