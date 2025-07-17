extends Node2D


var y1 = 70
var y2 = 110
var y3 = 150

var selectedQ = "Freeze"
var selectedE = "Speed"
var selectedGun = "Smg"

func _input(event):
	#LEFT CLICK DETECTION
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var mousePos = get_viewport().get_mouse_position()
			
			#CLICKING PLAY BUTTON
			if isHover(mousePos, 129, 197, 62, 30):
				var scene = load("res://scenes/World.tscn")
				var world = scene.instance()
				world.get_node("Player").q = selectedQ
				world.get_node("Player").e = selectedE
				world.get_node("Player").gunEquipped = selectedGun
				get_parent().add_child(world)
				queue_free()
			
			#CLICKING Q BOXES
			if isHover(mousePos, 32, 72, 64, 32):
				selectedQ = "Freeze"
				$selectionQ.position.y = y1
			elif isHover(mousePos, 32, 112, 64, 32):
				selectedQ = "Teleport"
				$selectionQ.position.y = y2
			elif isHover(mousePos, 32, 152, 64, 32):
				selectedQ = "Invulnerability"
				$selectionQ.position.y = y3
			
			#CLICKING E BOXES
			if isHover(mousePos, 128, 72, 64, 32):
				selectedE = "Speed"
				$selectionE.position.y = y1
			elif isHover(mousePos, 128, 112, 64, 32):
				selectedE = "Damage"
				$selectionE.position.y = y2
			elif isHover(mousePos, 128, 152, 64, 32):
				selectedE = "Heal"
				$selectionE.position.y = y3
			
			#CLICKING GUN BOXES
			if isHover(mousePos, 224, 72, 64, 32):
				selectedGun = "Smg"
				$selectionGun.position.y = y1
			elif isHover(mousePos, 224, 112, 64, 32):
				selectedGun = "Pistol"
				$selectionGun.position.y = y2
			elif isHover(mousePos, 224, 152, 64, 32):
				selectedGun = "Shotgun"
				$selectionGun.position.y = y3


#RETURN TRUE IF MOUSE IS HOVERING OVER
func isHover(mousePos, x, y, w, h):
	return (mousePos.x >= x and mousePos.x <= x + w and mousePos.y >= y and mousePos.y <= y + h)
