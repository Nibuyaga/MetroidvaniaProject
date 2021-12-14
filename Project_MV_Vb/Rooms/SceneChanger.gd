tool
extends Area2D

export(String, FILE) var next_scene_path = ""
export(Vector2) var new_player_pos = Vector2.ZERO


func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "next_scene_path must be set for the portal to work"
	else:
		return ""


func _on_SceneChanger_body_entered(body):
	# first line changes player data location
	Global.player_spawn_location = new_player_pos
	Global.goto_scene(next_scene_path)


