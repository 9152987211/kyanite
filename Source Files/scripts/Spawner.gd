extends KinematicBody2D


var type
var spawnTime
var spawnLength = 2000
var fadeInLength = 400
var fadeOutLength = 400
var enemySpawned = false
var animationCompleted = false


func _process(delta):
	#SPAWN ANIMATION EFFECT
	if enemySpawned and not animationCompleted:
		animationCompleted = true
		$Effect.visible = true
	
	
	#REMOVE THE SPAWNER ONCE THE ANIMATION HAS ENDED
	if OS.get_ticks_msec() >= spawnTime + spawnLength:
		queue_free()
	
	
	#SPAWN THE ENEMY
	if OS.get_ticks_msec() >= spawnTime + spawnLength - fadeOutLength and not enemySpawned:
		enemySpawned = true
		var scene
		if type == "Zombie":
			scene = load("res://scenes/Zombie.tscn")
		elif type == "Ninja":
			scene = load("res://scenes/Ninja.tscn")
		elif type == "Vampire":
			scene = load("res://scenes/Vampire.tscn")
		var enemy = scene.instance()
		enemy.position.x = position.x
		enemy.position.y = position.y - 3
		get_parent().get_parent().get_node("Enemies").add_child(enemy)
	
	
	#SMOKE FADE IN ANIMATION
	if OS.get_ticks_msec() <= spawnTime + fadeInLength:
		var ratio = float(OS.get_ticks_msec() - spawnTime) / fadeInLength
		if ratio > 1:
			ratio = 1
		$Sprite.modulate = Color(1, 1, 1, ratio)
	
	
	#SMOKE FADE OUT ANIMATION
	if OS.get_ticks_msec() >= spawnTime + spawnLength - fadeOutLength:
		var ratio = float(OS.get_ticks_msec() - (spawnTime + spawnLength - fadeOutLength)) / fadeOutLength
		if ratio > 1:
			ratio = 1
		$Sprite.modulate = Color(1, 1, 1, 1-ratio)
