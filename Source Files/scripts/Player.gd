extends KinematicBody2D


var velocity = Vector2.ZERO
var speed = 60
var friction = 0.8
var gunEquipped = "Smg" #Smg / Pistol / Shotgun
var rng = RandomNumberGenerator.new()
var maxHealth = 20
var health = maxHealth
var invincible = false
var iKeyReleased = true
var stats = false
var kKeyReleased = true
var numberOfKills = 0

var q = "Invulnerability" #Freeze / Teleport / Invulnerability
var e = "Heal" #Speed / Damage / Heal
var qCooldown = 20000
var eCooldown = 5000
var qUsed = false
var eUsed = false
var qTempTime = -99999999999
var eTempTime = -99999999999
var qBuffTempTime = -99999999999
var eBuffTempTime = -99999999999
var speedBuffAmount = 40
var speedBuffDuration = 2000
var speedBuffEnabled = false
var damageBuffAmount = 1.5 #Multiplier
var damageBuffDuration = 2000
var damageBuffEnabled = false
var healAmount = 4
var freezeDuration = 5000
var freezeEnabled = false
var teleportMargin = 16
var invulnerabilityBuffDuration = 5000
var invulnerabilityBuffEnabled = false


func _physics_process(delta):
	#PLAYER MOVEMENT
	var actualSpeed = speed
	if speedBuffEnabled == true:
		actualSpeed += speedBuffAmount
	var input_vector = Vector2.ZERO
	input_vector.x = boolToInt(Input.is_key_pressed(KEY_D)) - boolToInt(Input.is_key_pressed(KEY_A))
	input_vector.y = boolToInt(Input.is_key_pressed(KEY_S)) - boolToInt(Input.is_key_pressed(KEY_W))
	if input_vector.x == 0:
		velocity.x *= friction
	else:
		velocity.x = input_vector.x * actualSpeed
	if input_vector.y == 0:
		velocity.y *= friction
	else:
		velocity.y = input_vector.y * actualSpeed
	move_and_slide(velocity)
	
	
	#FACING DIRECTION
	if get_viewport().get_mouse_position().x >= position.x:
		$Standing.flip_h = false
		$Running.flip_h = false
	else:
		$Standing.flip_h = true
		$Running.flip_h = true
	
	
	#RUNNING ANIMATION
	if velocity.length() > 0.2:
		$Running.visible = true
		$Standing.visible = false
	else:
		$Running.visible = false
		$Standing.visible = true
	
	
	#GUN POINT DIRECTION
	if gunEquipped == "Smg":
		$Smg.visible = true
		$Pistol.visible = false
		$Shotgun.visible = false
		var gunPointDirection = Vector2.ZERO
		var mousePosition = get_viewport().get_mouse_position()
		gunPointDirection.x = mousePosition.x - position.x
		gunPointDirection.y = mousePosition.y - position.y
		var gunPointAngle = gunPointDirection.angle()
		if mousePosition.x >= position.x:
			$Smg/Sprite.position.x = $Smg.offset
			$Smg/Damage.position.x = $Smg.offset
			$Smg/Sprite.flip_h = false
			$Smg/Damage.flip_h = false
			$Smg.rotation = gunPointAngle
		else:
			$Smg/Sprite.position.x = -$Smg.offset
			$Smg/Damage.position.x = -$Smg.offset
			$Smg/Sprite.flip_h = true
			$Smg/Damage.flip_h = true
			$Smg.rotation = gunPointAngle + 135
	elif gunEquipped == "Pistol":
		$Smg.visible = false
		$Pistol.visible = true
		$Shotgun.visible = false
		var gunPointDirection = Vector2.ZERO
		var mousePosition = get_viewport().get_mouse_position()
		gunPointDirection.x = mousePosition.x - position.x
		gunPointDirection.y = mousePosition.y - position.y
		var gunPointAngle = gunPointDirection.angle()
		if mousePosition.x >= position.x:
			$Pistol/Sprite.position.x = $Pistol.offset
			$Pistol/Damage.position.x = $Pistol.offset
			$Pistol/Sprite.flip_h = false
			$Pistol/Damage.flip_h = false
			$Pistol.rotation = gunPointAngle
		else:
			$Pistol/Sprite.position.x = -$Pistol.offset
			$Pistol/Damage.position.x = -$Pistol.offset
			$Pistol/Sprite.flip_h = true
			$Pistol/Damage.flip_h = true
			$Pistol.rotation = gunPointAngle + 135
	elif gunEquipped == "Shotgun":
		$Smg.visible = false
		$Pistol.visible = false
		$Shotgun.visible = true
		var gunPointDirection = Vector2.ZERO
		var mousePosition = get_viewport().get_mouse_position()
		gunPointDirection.x = mousePosition.x - position.x
		gunPointDirection.y = mousePosition.y - position.y
		var gunPointAngle = gunPointDirection.angle()
		if mousePosition.x >= position.x:
			$Shotgun/Sprite.position.x = $Shotgun.offset
			$Shotgun/Damage.position.x = $Shotgun.offset
			$Shotgun/Sprite.flip_h = false
			$Shotgun/Damage.flip_h = false
			$Shotgun.rotation = gunPointAngle
		else:
			$Shotgun/Sprite.position.x = -$Shotgun.offset
			$Shotgun/Damage.position.x = -$Shotgun.offset
			$Shotgun/Sprite.flip_h = true
			$Shotgun/Damage.flip_h = true
			$Shotgun.rotation = gunPointAngle + 135


func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		#LEFT CLICK HELD DOWN SO SHOOT
		if gunEquipped == "Smg":
			if $Smg.shooting:
				if OS.get_ticks_msec() >= $Smg.shootTime + $Smg.cooldown:
					$Smg.shooting = false
			if not $Smg.shooting:
				$Smg.shooting = true
				$Smg.shootTime = OS.get_ticks_msec()
				var scene = load("res://scenes/Bullet.tscn")
				var bullet = scene.instance()
				var mousePosition = get_viewport().get_mouse_position()
				var startPosition = position
				var dir = Vector2.ZERO
				dir.x = mousePosition.x - startPosition.x
				dir.y = mousePosition.y - startPosition.y
				var a = dir.angle() + deg2rad(rng.randf_range(-$Smg.innacuracy, $Smg.innacuracy))
				var newDir = Vector2(cos(a), sin(a)) * dir.length()
				dir = newDir
				bullet.dir = dir.normalized()
				bullet.position = dir.normalized()
				bullet.position.x *= $Smg.offset
				bullet.position.y *= $Smg.offset
				bullet.position.x += startPosition.x
				bullet.position.y += startPosition.y
				bullet.gun = gunEquipped
				get_parent().get_node("Bullets").add_child(bullet)
				#SOUND EFFECT
				if get_parent().get_parent().soundOn:
					var sound = AudioStreamPlayer.new()
					sound.stream = load("res://sounds/guns/Smg.wav")
					sound.volume_db = -20
					add_child(sound)
					sound.play()
		elif gunEquipped == "Pistol":
			if $Pistol.shooting:
				if OS.get_ticks_msec() >= $Pistol.shootTime + $Pistol.cooldown:
					$Pistol.shooting = false
			if not $Pistol.shooting:
				$Pistol.shooting = true
				$Pistol.shootTime = OS.get_ticks_msec()
				var scene = load("res://scenes/Bullet.tscn")
				var bullet = scene.instance()
				var mousePosition = get_viewport().get_mouse_position()
				var startPosition = position
				var dir = Vector2.ZERO
				dir.x = mousePosition.x - startPosition.x
				dir.y = mousePosition.y - startPosition.y
				var a = dir.angle() + deg2rad(rng.randf_range(-$Pistol.innacuracy, $Pistol.innacuracy))
				var newDir = Vector2(cos(a), sin(a)) * dir.length()
				dir = newDir
				bullet.dir = dir.normalized()
				bullet.position = dir.normalized()
				bullet.position.x *= $Pistol.offset
				bullet.position.y *= $Pistol.offset
				bullet.position.x += startPosition.x
				bullet.position.y += startPosition.y
				bullet.gun = gunEquipped
				get_parent().get_node("Bullets").add_child(bullet)
				#SOUND EFFECT
				if get_parent().get_parent().soundOn:
					var sound = AudioStreamPlayer.new()
					sound.stream = load("res://sounds/guns/Pistol.wav")
					sound.volume_db = -20
					add_child(sound)
					sound.play()
		elif gunEquipped == "Shotgun":
			if $Shotgun.shooting:
				if OS.get_ticks_msec() >= $Shotgun.shootTime + $Shotgun.cooldown:
					$Shotgun.shooting = false
			if not $Shotgun.shooting:
				$Shotgun.shooting = true
				$Shotgun.shootTime = OS.get_ticks_msec()
				for i in range(0, $Shotgun.numberOfBullets):
					var scene = load("res://scenes/Bullet.tscn")
					var bullet = scene.instance()
					var mousePosition = get_viewport().get_mouse_position()
					var startPosition = position
					var dir = Vector2.ZERO
					dir.x = mousePosition.x - startPosition.x
					dir.y = mousePosition.y - startPosition.y
					var a = dir.angle() + deg2rad(rng.randf_range(-$Shotgun.innacuracy, $Shotgun.innacuracy))
					var newDir = Vector2(cos(a), sin(a)) * dir.length()
					dir = newDir
					bullet.dir = dir.normalized()
					bullet.position = dir.normalized()
					bullet.position.x *= $Shotgun.offset
					bullet.position.y *= $Shotgun.offset
					bullet.position.x += startPosition.x
					bullet.position.y += startPosition.y
					bullet.gun = gunEquipped
					get_parent().get_node("Bullets").add_child(bullet)
				#SOUND EFFECT
				if get_parent().get_parent().soundOn:
					var sound = AudioStreamPlayer.new()
					sound.stream = load("res://sounds/guns/Shotgun.wav")
					sound.volume_db = -15
					add_child(sound)
					sound.play()
	
	
	#Q ABILITY PRESSED
	if Input.is_key_pressed(KEY_Q):
		if OS.get_ticks_msec() >= qTempTime + qCooldown:
			qTempTime = OS.get_ticks_msec()
			useQ()
	
	#E ABILITY PRESSED
	if Input.is_key_pressed(KEY_E):
		if OS.get_ticks_msec() >= eTempTime + eCooldown:
			eTempTime = OS.get_ticks_msec()
			useE()
	
	
	#HANDLE SPEED BUFF
	if speedBuffEnabled == true:
		if OS.get_ticks_msec() >= eBuffTempTime + speedBuffDuration:
			speedBuffEnabled = false
		
		$Running.speed_scale = 2
	else:
		$Running.speed_scale = 1
	
	
	#HANDLE DAMAGE BUFF
	if damageBuffEnabled == true:
		if OS.get_ticks_msec() >= eBuffTempTime + damageBuffDuration:
			damageBuffEnabled = false
		
		$Smg/Sprite.visible = false
		$Pistol/Sprite.visible = false
		$Shotgun/Sprite.visible = false
		$Smg/Damage.visible = true
		$Pistol/Damage.visible = true
		$Shotgun/Damage.visible = true
	else:
		$Smg/Sprite.visible = true
		$Pistol/Sprite.visible = true
		$Shotgun/Sprite.visible = true
		$Smg/Damage.visible = false
		$Pistol/Damage.visible = false
		$Shotgun/Damage.visible = false
	
	
	#HANDLE FREEZE
	if freezeEnabled == true:
		if OS.get_ticks_msec() >= qBuffTempTime + freezeDuration:
			freezeEnabled = false
	
	
	#HANDLE INVULNERABILITY
	if invulnerabilityBuffEnabled == true:
		$Invuln.visible = true
		if OS.get_ticks_msec() >= qBuffTempTime + invulnerabilityBuffDuration:
			invulnerabilityBuffEnabled = false
	else:
		$Invuln.visible = false
	
	
	#CHECK TO SEE IF PLAYER SHOULD DIE
	if health <= 0:
		var diedScene = load("res://scenes/Died.tscn")
		var ds = diedScene.instance()
		var game = get_parent().get_parent()
		game.add_child(ds)
		ds.waveReached = get_parent().wave
		get_parent().queue_free()


#TOGGLE INVINCIBILITY USING 'I' KEY AND STATS USING 'K'
func _input(ev):
	var event = Input.is_key_pressed(KEY_I)
	
	if event == true and iKeyReleased == true:
		#REMOVED THIS LINE OF CODE TO DISABLE INVINCIBLE MODE
		#invincible = not invincible
		iKeyReleased = false
	
	if event == false:
		iKeyReleased = true
	
	
	event = Input.is_key_pressed(KEY_K)
	
	if event == true and kKeyReleased == true:
		stats = not stats
		kKeyReleased = false
	
	if event == false:
		kKeyReleased = true


func useQ():
	if q == "Freeze":
		qBuffTempTime = OS.get_ticks_msec()
		freezeEnabled = true
	elif q == "Teleport":
		var mousePos = get_viewport().get_mouse_position()
		var tpLocationX = clamp(mousePos.x, teleportMargin, 320-teleportMargin)
		var tpLocationY = clamp(mousePos.y, teleportMargin, 192-teleportMargin)
		position.x = tpLocationX
		position.y = tpLocationY
	elif q == "Invulnerability":
		qBuffTempTime = OS.get_ticks_msec()
		invulnerabilityBuffEnabled = true


func useE():
	if e == "Speed":
		eBuffTempTime = OS.get_ticks_msec()
		speedBuffEnabled = true
	elif e == "Damage":
		eBuffTempTime = OS.get_ticks_msec()
		damageBuffEnabled = true
	elif e == "Heal":
		health = clamp(health + healAmount, 0, maxHealth)


func takeDamage(amount):
	if (not invincible) and (not invulnerabilityBuffEnabled):
		health -= amount


#CONVERT TRUE TO 1 AND FALSE TO 0 (USED FOR MOVEMENT CONTROLS FOR THE PLAYER)
func boolToInt(b):
	if b == true:
		return 1
	else:
		return 0
