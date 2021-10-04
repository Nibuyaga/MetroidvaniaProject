extends Node2D

func update_weapon(delta, aim, attack=false):
	var space_state = get_world_2d().direct_space_state
	var to = global_position
	var wall_ray_results = space_state.intersect_ray(global_position, to, [self])
