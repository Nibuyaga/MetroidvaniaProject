extends Node2D

var max_length = 256
var current_length = 0
var connected_length = 0
var shot_speed = 1024
var connected = null
var wind_speed = 16
var body

func _ready():
	$hook_line.set_point_position(0, Vector2(0,0))
	$hook_line.set_point_position(1, Vector2(0,0))
	body = get_parent().get_parent()

func fire_hook(delta):
	current_length += delta * shot_speed
	if current_length > max_length:
		$hook_ray.enabled = false
		current_length = 0
	$hook_line.set_point_position(1, Vector2(0,-current_length))	
	$hook_ray.cast_to = Vector2(0,current_length)
	if $hook_ray.is_colliding():
		connected_length = 64 #current_length
		current_length = 0
		connected = $hook_ray.get_collision_point()

func connection(delta):
	var distance = body.global_position.distance_to(connected)
	if distance >= connected_length:
		var normal = (body.global_position - connected).normalized()
		var intention = body.position - (connected + normal  * (connected_length))
		body.velocity -= intention
	$hook_line.set_point_position(1, to_local(connected))

func update_weapon(delta, aim, attack=false):
	if not connected == null:
		body.air_drag = 4
		body.speed = 500
		body.minimum_move = 0

		connection(delta)
		if attack:
			connected = null
			$hook_line.set_point_position(1, Vector2(0,0))
			# HACK: revert to the set value
			body.air_drag = 0.5 
			body.speed = 3200
			body.minimum_move = 8
	else:
		if attack:
			$hook_ray.enabled = true
		if $hook_ray.enabled:
			fire_hook(delta)


