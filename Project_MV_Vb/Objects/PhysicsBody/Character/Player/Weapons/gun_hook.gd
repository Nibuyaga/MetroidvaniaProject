extends Node2D

var is_firing = false
var max_length = 128

func update_weapon(delta, aim, attack=false):
	$Line2D.set_point_position(0, Vector2(0,1))
	$Line2D.set_point_position(1, Vector2(0,-max_length))

	
	
