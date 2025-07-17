extends Node2D


var WORLD_W = 320
var WORLD_H = 192
var rng = RandomNumberGenerator.new()
var wave = 1
var waveStarted = false
var waveEndTime = OS.get_ticks_msec()
var waveBreakLength = 5000
var numberOfZombies = [10, 15, 20, 25, 0, 50, 20, 40, 40, 90]
var numberOfNinjas = [0, 2, 4, 8, 0, 0, 50, 30, 5, 15]
var numberOfVampires = [0, 0, 0, 0, 1, 0, 0, 2, 3, 20]
var spawnedZombies = 0
var spawnedNinjas = 0
var spawnedVampires = 0


func _ready():
	rng.randomize()
	
	
	#PLACE FLOOR TILES
	for x in range(0, int(WORLD_W/8)):
		for y in range(0, int(WORLD_H/8)):
			$TileMap.set_cell(x, y, 0)
			if rng.randf() < 0.02:
				$TileMap.set_cell(x, y, 1)
	
	
	#PLACE WALLS
	for x in range(0, int(WORLD_W/8)):
		var scene = load("res://scenes/Wall.tscn")
		var wall = scene.instance()
		wall.position.x = x * 8
		wall.position.y = 0
		$Walls.add_child(wall)
	for x in range(0, int(WORLD_W/8)):
		var scene = load("res://scenes/Wall.tscn")
		var wall = scene.instance()
		wall.position.x = x * 8
		wall.position.y = WORLD_H - 8
		$Walls.add_child(wall)
	for y in range(0, int(WORLD_H/8)):
		var scene = load("res://scenes/Wall.tscn")
		var wall = scene.instance()
		wall.position.x = 0
		wall.position.y = y * 8
		$Walls.add_child(wall)
	for y in range(0, int(WORLD_H/8)):
		var scene = load("res://scenes/Wall.tscn")
		var wall = scene.instance()
		wall.position.x = WORLD_W - 8
		wall.position.y = y * 8
		$Walls.add_child(wall)


func _process(delta):
	
	if not waveStarted:
		if OS.get_ticks_msec() >= waveEndTime + waveBreakLength:
			waveStarted = true
	
	
	if waveStarted:
		var everythingSpawned = true
		if spawnedZombies < numberOfZombies[wave-1]:
			everythingSpawned = false
			if rng.randf() < 0.01:
				spawnEnemy("Zombie")
				spawnedZombies += 1
		if spawnedNinjas < numberOfNinjas[wave-1]:
			everythingSpawned = false
			if rng.randf() < 0.01:
				spawnEnemy("Ninja")
				spawnedNinjas += 1
		if spawnedVampires < numberOfVampires[wave-1]:
			everythingSpawned = false
			if rng.randf() < 0.01:
				spawnEnemy("Vampire")
				spawnedVampires += 1
		
		
		if everythingSpawned:
			if get_node("Enemies").get_children().size() == 0 and get_node("Spawners").get_children().size() == 0:
				endWave()


func spawnEnemy(t):
	var scene = load("res://scenes/Spawner.tscn")
	var spawner = scene.instance()
	spawner.position.x = int(rng.randf_range(16, WORLD_W-16))
	spawner.position.y = int(rng.randf_range(16, WORLD_H-16))
	spawner.type = t
	spawner.spawnTime = OS.get_ticks_msec()
	$Spawners.add_child(spawner)


func endWave():
	if wave == 10:
		#GAME WON
		var scene = load("res://scenes/Won.tscn")
		var won = scene.instance()
		get_parent().add_child(won)
		queue_free()
	
	wave += 1
	$UI.updateWaveNumber()
	waveStarted = false
	waveEndTime = OS.get_ticks_msec()
	spawnedZombies = 0
	spawnedNinjas = 0
	spawnedVampires = 0
