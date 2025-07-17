extends Node2D


var waveReached = 0
var waveAdded = false
var waveColour = Color(0.5, 0.5, 1, 1)
var waveX = 211
var waveX2 = 218
var waveX3 = 225
var waveY = 82


func _process(delta):
	
	#ADD THE WAVE REACHED TEXT
	if waveReached > 0 and waveAdded == false:
		waveAdded = true
		if waveReached < 10:
			var scene = load("res://scenes/PixelNumber.tscn")
			var num = scene.instance()
			num.position.x = waveX
			num.position.y = waveY
			num.frame = waveReached
			num.modulate = waveColour
			add_child(num)
		elif waveReached < 100:
			var num1Value = floor(waveReached / 10)
			var num2Value = waveReached % 10
			
			var scene1 = load("res://scenes/PixelNumber.tscn")
			var num1 = scene1.instance()
			num1.position.x = waveX
			num1.position.y = waveY
			num1.frame = num1Value
			num1.modulate = waveColour
			add_child(num1)
			
			var scene2 = load("res://scenes/PixelNumber.tscn")
			var num2 = scene2.instance()
			num2.position.x = waveX2
			num2.position.y = waveY
			num2.frame = num2Value
			num2.modulate = waveColour
			add_child(num2)
		elif waveReached < 1000:
			var num1Value = floor(waveReached / 100)
			var num2Value = int(floor(waveReached / 10)) % 10
			var num3Value = waveReached % 10
			
			var scene1 = load("res://scenes/PixelNumber.tscn")
			var num1 = scene1.instance()
			num1.position.x = waveX
			num1.position.y = waveY
			num1.frame = num1Value
			num1.modulate = waveColour
			add_child(num1)
			
			var scene2 = load("res://scenes/PixelNumber.tscn")
			var num2 = scene2.instance()
			num2.position.x = waveX2
			num2.position.y = waveY
			num2.frame = num2Value
			num2.modulate = waveColour
			add_child(num2)
			
			var scene3 = load("res://scenes/PixelNumber.tscn")
			var num3 = scene3.instance()
			num3.position.x = waveX3
			num3.position.y = waveY
			num3.frame = num3Value
			num3.modulate = waveColour
			add_child(num3)


#PRESS ESCAPE TO RETURN TO MENU
func _input(ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		var scene = load("res://scenes/Menu.tscn")
		var menu = scene.instance()
		get_parent().add_child(menu)
		queue_free()
