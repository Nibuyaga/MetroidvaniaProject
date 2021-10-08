extends Area2D

export(String, FILE) var next_scene_path = ""
export(Vector2) var new_player_pos = Vector2.ZERO

func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "next_scene_path must be set for the portal to work"
	else:
		return ""



func _on_SceneChanger_body_entered(body):
	
	new_player_pos.y += body.global_position.y - self.global_position.y
	
	Global.player_spawn_location = new_player_pos
	
	
	if Global.goto_scene(next_scene_path) != OK:
		# error handling
		print("Error: Unavailable scene (or other errors)")
