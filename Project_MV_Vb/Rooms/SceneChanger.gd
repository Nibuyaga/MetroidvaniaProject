extends Area2D

export(String, FILE) var next_scene_path = ""
export(Vector2) var new_player_pos = Vector2.ZERO

func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "next_scene_path must be set for the portal to work"
	else:
		return ""

func _on_SceneChanger_body_entered(body):
	var root = get_tree().get_current_scene()
	root.swap_scene(next_scene_path)
	var player = root.get_node('Player')
	player.position.x = new_player_pos.x
	player.position.y = new_player_pos.y 
