extends Node2D


#PRESS ESCAPE TO RETURN TO MENU
func _input(ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		var scene = load("res://scenes/Menu.tscn")
		var menu = scene.instance()
		get_parent().add_child(menu)
		queue_free()
