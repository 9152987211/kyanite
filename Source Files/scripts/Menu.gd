extends Node2D


var buttonOffset = 2
var highlightColor = Color(0.9, 0.9, 0.9, 1)
var normalColor = Color(1, 1, 1, 1)
var buttonH = 15
var playW = 50
var profileW = 80
var exitW = 42
var music
var musicVolume = -25


func _ready():
	#MENU MUSIC
	music = AudioStreamPlayer.new()
	music.stream = load("res://sounds/music/menu.wav")
	if get_parent().musicOn:
		music.volume_db = musicVolume
	else:
		music.volume_db = -999999
	add_child(music)
	music.play()


func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	
	
	#HIGHLIGHT PLAY BUTTON
	if isHover(mousePos, $Play.position.x, $Play.position.y, playW, buttonH):
		$Play.modulate = highlightColor
	else:
		$Play.modulate = normalColor
	
	
	#HIGHLIGHT EXIT BUTTON
	if isHover(mousePos, $Exit.position.x, $Exit.position.y, exitW, buttonH):
		$Exit.modulate = highlightColor
	else:
		$Exit.modulate = normalColor
	
	
	#LOOP MENU MUSIC
	if not music.playing:
		music.play()
	
	if get_parent().musicOn:
		music.volume_db = musicVolume
	else:
		music.volume_db = -999999
	
	
	#UPDATE SOUND ICONS
	$MusicOff.visible = not get_parent().musicOn
	$SoundOff.visible = not get_parent().soundOn

func _input(event):
	#LEFT CLICK DETECTION
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var mousePos = get_viewport().get_mouse_position()
			
			
			#CLICKING PLAY BUTTON
			if isHover(mousePos, $Play.position.x, $Play.position.y, playW, buttonH):
				var scene = load("res://scenes/loadout.tscn")
				var loadout = scene.instance()
				get_parent().add_child(loadout)
				queue_free()
			
			
			#CLICKING EXIT BUTTON
			if isHover(mousePos, $Exit.position.x, $Exit.position.y, exitW, buttonH):
				get_tree().quit()
			
			
			#TOGGLING MUTE MUSIC
			if isHover(mousePos, $MusicOff.position.x, $MusicOff.position.y, 12, 10):
				get_parent().musicOn = not get_parent().musicOn
			
			
			#TOGGLING MUTE SOUND
			if isHover(mousePos, $SoundOff.position.x, $SoundOff.position.y, 16, 10):
				get_parent().soundOn = not get_parent().soundOn


#RETURN TRUE IF MOUSE IS HOVERING OVER
func isHover(mousePos, x, y, w, h):
	x -= buttonOffset
	y -= buttonOffset
	w += (2 * buttonOffset)
	h += (2 * buttonOffset)
	var hover = (mousePos.x >= x and mousePos.x <= x + w and mousePos.y >= y and mousePos.y <= y + h)
	return hover
