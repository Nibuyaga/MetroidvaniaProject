extends Node2D

var max_length = 256
var current_length = 0
var shot_speed = 1024
var connected = null

func _ready():
	$hook_line.set_point_position(0, Vector2(0,0))
	$hook_line.set_point_position(1, Vector2(0,0))

func fire_hook(delta):
	current_length += delta * shot_speed
	if current_length > max_length:
		$hook_ray.enabled = false
		current_length = 0
	$hook_line.set_point_position(1, Vector2(0,-current_length))	
	$hook_ray.cast_to = Vector2(0,current_length)
	if $hook_ray.is_colliding():
		connected = $hook_ray.get_collision_point()

func connection(delta):
	$hook_line.set_point_position(1, to_local(connected))
		
func update_weapon(delta, aim, attack=false):
	if not connected == null:
		connection(delta)
		if attack:
			connected = null
	else:
		if attack:
			$hook_ray.enabled = true
		if $hook_ray.enabled:
			fire_hook(delta)


