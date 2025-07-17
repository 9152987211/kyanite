extends KinematicBody2D


var health = 12
var speed = 65
var rng = RandomNumberGenerator.new()
var directionChanged = 0
var directionChangeLength = 500
var directionOffset = Vector2.ZERO
var directionChangeAmount = 40
var attackDamage = 4
var attackCooldown = 600
var attackLastHit = 0


func _physics_process(delta):
	rng.randomize()
	
	
	#MOVEMENT
	if OS.get_ticks_msec() >= directionChanged + directionChangeLength:
		directionChanged = OS.get_ticks_msec()
		directionOffset.x = rng.randf_range(-directionChangeAmount, directionChangeAmount)
		directionOffset.y = rng.randf_range(-directionChangeAmount, directionChangeAmount)
	var player = get_parent().get_parent().get_node("Player")
	var dir = Vector2(player.position.x - position.x, player.position.y - position.y)
	if dir.length() > directionChangeAmount * 0.6:
		dir.x += directionOffset.x
		dir.y += directionOffset.y
	dir = dir.normalized()
	dir.x = dir.x * speed
	dir.y = dir.y * speed
	if get_parent().get_parent().get_node("Player").freezeEnabled == false:
		move_and_slide(dir)
	
	
	#DEATH
	if health <= 0:
		get_parent().get_parent().get_node("Player").numberOfKills += 1
		queue_free()
	
	
	#DAMAGING PLAYER
	if $Area2D.get_overlapping_areas().size() > 0 and not get_parent().get_parent().get_node("Player").freezeEnabled:
		var n = $Area2D.get_overlapping_areas()[0].get_parent().name
		var w = get_parent().get_parent()
		if n.substr(0, 8) == "@Player" or n == "Player":
			if OS.get_ticks_msec() >= attackLastHit + attackCooldown:
				attackLastHit = OS.get_ticks_msec()
				w.get_node("Player").takeDamage(attackDamage)
	
	
	#NO RUNNING ANIMATION WHEN FROZEN AND ENABLE FROZEN SPRITE
	if get_parent().get_parent().get_node("Player").freezeEnabled == true:
		$AnimatedSprite.visible = false
		$Frozen.visible = true
	else:
		$AnimatedSprite.visible = true
		$Frozen.visible = false
