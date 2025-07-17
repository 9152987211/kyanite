extends CanvasLayer


var previousKillsNumber = 0
var previousEnemiesOnScreenNumber = 0


func _ready():
	updateWaveNumber()
	updateKillsNumber()
	updateEnemiesOnScreenNumber()


func _process(delta):
	#UPATE HEALTH BAR
	var health = get_parent().get_node("Player").health
	if health < 0:
		health = 0
	$Health.rect_position.y = 206 + 20 - health
	$Health.rect_size.y = health
	
	
	if get_parent().get_node("Player").numberOfKills != previousKillsNumber:
		updateKillsNumber()
	previousKillsNumber = get_parent().get_node("Player").numberOfKills
	if get_parent().get_node("Enemies").get_child_count() != previousEnemiesOnScreenNumber:
		updateEnemiesOnScreenNumber()
	previousEnemiesOnScreenNumber = get_parent().get_node("Enemies").get_child_count()
	
	
	#UPDATE INVINCIBLE TOGGLE TEXT
	if get_parent().get_node("Player").invincible == true:
		$InvincibleText.frame = 0
	else:
		$InvincibleText.frame = 1
	
	
	#UPDATE STATS TOGGLE TEXT
	if get_parent().get_node("Player").stats == true:
		$StatsText.frame = 0
	else:
		$StatsText.frame = 1
	
	
	#UPDATE CURRENT GUN
	if get_parent().get_node("Player").gunEquipped == "Smg":
		$Guns/Smg.visible = true
		$Guns/Pistol.visible = false
		$Guns/Shotgun.visible = false
	elif get_parent().get_node("Player").gunEquipped == "Pistol":
		$Guns/Smg.visible = false
		$Guns/Pistol.visible = true
		$Guns/Shotgun.visible = false
	elif get_parent().get_node("Player").gunEquipped == "Shotgun":
		$Guns/Smg.visible = false
		$Guns/Pistol.visible = false
		$Guns/Shotgun.visible = true
	
	
	#UPDATE CURRENT Q
	if get_parent().get_node("Player").q == "Freeze":
		$Q/Freeze.visible = true
		$Q/Teleport.visible = false
		$Q/Invulnerability.visible = false
	elif get_parent().get_node("Player").q == "Teleport":
		$Q/Freeze.visible = false
		$Q/Teleport.visible = true
		$Q/Invulnerability.visible = false
	elif get_parent().get_node("Player").q == "Invulnerability":
		$Q/Freeze.visible = false
		$Q/Teleport.visible = false
		$Q/Invulnerability.visible = true
	
	
	#UPDATE CURRENT E
	if get_parent().get_node("Player").e == "Speed":
		$E/Speed.visible = true
		$E/Damage.visible = false
		$E/Heal.visible = false
	elif get_parent().get_node("Player").e == "Damage":
		$E/Speed.visible = false
		$E/Damage.visible = true
		$E/Heal.visible = false
	elif get_parent().get_node("Player").e == "Heal":
		$E/Speed.visible = false
		$E/Damage.visible = false
		$E/Heal.visible = true
	
	
	#UPDATE Q COOLDOWN
	var timeSinceLastQUse = OS.get_ticks_msec() - get_parent().get_node("Player").qTempTime
	var barCooldown = get_parent().get_node("Player").qCooldown - clamp(timeSinceLastQUse, 0, get_parent().get_node("Player").qCooldown)
	var rectHeight = 20 * (float(barCooldown) / float(get_parent().get_node("Player").qCooldown))
	var rectY = 206 + (20 - rectHeight)
	$Q/Cooldown.rect_position.y = rectY
	$Q/Cooldown.rect_size.y = rectHeight
	
	
	#UPDATE E COOLDOWN
	var timeSinceLastEUse = OS.get_ticks_msec() - get_parent().get_node("Player").eTempTime
	barCooldown = get_parent().get_node("Player").eCooldown - clamp(timeSinceLastEUse, 0, get_parent().get_node("Player").eCooldown)
	rectHeight = 20 * (float(barCooldown) / float(get_parent().get_node("Player").eCooldown))
	rectY = 206 + (20 - rectHeight)
	$E/Cooldown.rect_position.y = rectY
	$E/Cooldown.rect_size.y = rectHeight
	
	
	#UPDATE STATS VISIBILITY
	if get_parent().get_node("Player").stats:
		$KillsNumbers.visible = true
		$EnemiesOnScreen.visible = true
		$kills.visible = true
		$enemiesOnScreen.visible = true
	else:
		$KillsNumbers.visible = false
		$EnemiesOnScreen.visible = false
		$kills.visible = false
		$enemiesOnScreen.visible = false


func updateWaveNumber():
	#CLEAR WAVE NUMBER
	var wave = get_parent().wave
	for c in get_node("WaveNumbers").get_children():
		c.free()
	
	#ADD UPDATED WAVE NUMBER
	if wave < 10:
		var scene = load("res://scenes/PixelNumber.tscn")
		var num = scene.instance()
		num.position.x = 48
		num.position.y = 206
		num.frame = wave
		num.modulate = Color(0.6, 0.6, 0.8, 1)
		get_node("WaveNumbers").add_child(num)
	elif wave < 100:
		var num1Value = floor(wave / 10)
		var num2Value = wave % 10
		
		var scene1 = load("res://scenes/PixelNumber.tscn")
		var num1 = scene1.instance()
		num1.position.x = 48
		num1.position.y = 206
		num1.frame = num1Value
		num1.modulate = Color(0.6, 0.6, 0.8, 1)
		get_node("WaveNumbers").add_child(num1)
		
		var scene2 = load("res://scenes/PixelNumber.tscn")
		var num2 = scene2.instance()
		num2.position.x = 55
		num2.position.y = 206
		num2.frame = num2Value
		num2.modulate = Color(0.6, 0.6, 0.8, 1)
		get_node("WaveNumbers").add_child(num2)
	elif wave < 1000:
		var num1Value = floor(wave / 100)
		var num2Value = int(floor(wave / 10)) % 10
		var num3Value = wave % 10
		
		var scene1 = load("res://scenes/PixelNumber.tscn")
		var num1 = scene1.instance()
		num1.position.x = 48
		num1.position.y = 206
		num1.frame = num1Value
		num1.modulate = Color(0.6, 0.6, 0.8, 1)
		get_node("WaveNumbers").add_child(num1)
		
		var scene2 = load("res://scenes/PixelNumber.tscn")
		var num2 = scene2.instance()
		num2.position.x = 55
		num2.position.y = 206
		num2.frame = num2Value
		num2.modulate = Color(0.6, 0.6, 0.8, 1)
		get_node("WaveNumbers").add_child(num2)
		
		var scene3 = load("res://scenes/PixelNumber.tscn")
		var num3 = scene3.instance()
		num3.position.x = 62
		num3.position.y = 206
		num3.frame = num3Value
		num3.modulate = Color(0.6, 0.6, 0.8, 1)
		get_node("WaveNumbers").add_child(num3)


func updateKillsNumber():
	var x = 60
	var y = 18
	#CLEAR KILLS NUMBER
	var kills = get_parent().get_node("Player").numberOfKills
	for c in get_node("KillsNumbers").get_children():
		c.free()
	
	if kills < 10:
		var scene = load("res://scenes/PixelNumber.tscn")
		var num = scene.instance()
		num.position.x = x
		num.position.y = y
		num.frame = kills
		num.modulate = Color(0.6, 1, 0.6, 1)
		get_node("KillsNumbers").add_child(num)
	elif kills < 100:
		var num1Value = floor(kills / 10)
		var num2Value = kills % 10
		
		var scene1 = load("res://scenes/PixelNumber.tscn")
		var num1 = scene1.instance()
		num1.position.x = x
		num1.position.y = y
		num1.frame = num1Value
		num1.modulate = Color(0.6, 1, 0.6, 1)
		get_node("KillsNumbers").add_child(num1)
		
		var scene2 = load("res://scenes/PixelNumber.tscn")
		var num2 = scene2.instance()
		num2.position.x = x + 7
		num2.position.y = y
		num2.frame = num2Value
		num2.modulate = Color(0.6, 1, 0.6, 1)
		get_node("KillsNumbers").add_child(num2)
	elif kills < 1000:
		var num1Value = floor(kills / 100)
		var num2Value = int(floor(kills / 10)) % 10
		var num3Value = kills % 10
		
		var scene1 = load("res://scenes/PixelNumber.tscn")
		var num1 = scene1.instance()
		num1.position.x = x
		num1.position.y = y
		num1.frame = num1Value
		num1.modulate = Color(0.6, 1, 0.6, 1)
		get_node("KillsNumbers").add_child(num1)
		
		var scene2 = load("res://scenes/PixelNumber.tscn")
		var num2 = scene2.instance()
		num2.position.x = x + 7
		num2.position.y = y
		num2.frame = num2Value
		num2.modulate = Color(0.6, 1, 0.6, 1)
		get_node("KillsNumbers").add_child(num2)
		
		var scene3 = load("res://scenes/PixelNumber.tscn")
		var num3 = scene3.instance()
		num3.position.x = x + 14
		num3.position.y = y
		num3.frame = num3Value
		num3.modulate = Color(0.6, 1, 0.6, 1)
		get_node("KillsNumbers").add_child(num3)


func updateEnemiesOnScreenNumber():
	var x = 142
	var y = 26
	#CLEAR ENEMIES NUMBER
	var enemies = get_parent().get_node("Enemies").get_child_count()
	for c in get_node("EnemiesOnScreen").get_children():
		c.free()
	
	if enemies < 10:
		var scene = load("res://scenes/PixelNumber.tscn")
		var num = scene.instance()
		num.position.x = x
		num.position.y = y
		num.frame = enemies
		num.modulate = Color(0.6, 1, 0.6, 1)
		get_node("EnemiesOnScreen").add_child(num)
	elif enemies < 100:
		var num1Value = floor(enemies / 10)
		var num2Value = enemies % 10
		
		var scene1 = load("res://scenes/PixelNumber.tscn")
		var num1 = scene1.instance()
		num1.position.x = x
		num1.position.y = y
		num1.frame = num1Value
		num1.modulate = Color(0.6, 1, 0.6, 1)
		get_node("EnemiesOnScreen").add_child(num1)
		
		var scene2 = load("res://scenes/PixelNumber.tscn")
		var num2 = scene2.instance()
		num2.position.x = x + 7
		num2.position.y = y
		num2.frame = num2Value
		num2.modulate = Color(0.6, 1, 0.6, 1)
		get_node("EnemiesOnScreen").add_child(num2)
	elif enemies < 1000:
		var num1Value = floor(enemies / 100)
		var num2Value = int(floor(enemies / 10)) % 10
		var num3Value = enemies % 10
		
		var scene1 = load("res://scenes/PixelNumber.tscn")
		var num1 = scene1.instance()
		num1.position.x = x
		num1.position.y = y
		num1.frame = num1Value
		num1.modulate = Color(0.6, 1, 0.6, 1)
		get_node("EnemiesOnScreen").add_child(num1)
		
		var scene2 = load("res://scenes/PixelNumber.tscn")
		var num2 = scene2.instance()
		num2.position.x = x + 7
		num2.position.y = y
		num2.frame = num2Value
		num2.modulate = Color(0.6, 1, 0.6, 1)
		get_node("EnemiesOnScreen").add_child(num2)
		
		var scene3 = load("res://scenes/PixelNumber.tscn")
		var num3 = scene3.instance()
		num3.position.x = x + 14
		num3.position.y = y
		num3.frame = num3Value
		num3.modulate = Color(0.6, 1, 0.6, 1)
		get_node("EnemiesOnScreen").add_child(num3)
