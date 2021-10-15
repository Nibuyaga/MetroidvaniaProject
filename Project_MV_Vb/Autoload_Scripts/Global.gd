extends Node


var current_scene = null	# creates a variable for the "current level"
var player_spawn_location = null	# variable for player location in the scene
var player_data

func _ready():
	
	var root = get_tree().get_root()	# shortcut var for getting the root
	
	current_scene = root.get_child(root.get_child_count() - 1)
	# gets the last child of the root, which generally is the loaded scene, the current level


func goto_scene(path):
	
	call_deferred("_deferred_goto_scene", path)
	# call_deferred starts the function after all the code from the current scene has been completed


func _deferred_goto_scene(path):
	
	current_scene.free()
	
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()
	
	get_tree().get_root().add_child(current_scene)
	
