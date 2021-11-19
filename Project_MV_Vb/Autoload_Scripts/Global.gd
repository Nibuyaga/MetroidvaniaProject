extends Node

# ! At the moment the goto_scene and their variables are unused!

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
	



var player_ccl = null
var camera_ccl = null
var current_scene_ccl = null
onready var world_root_ccl = get_node_or_null("/root/WorldRoot")
var roomsize_ccl = null

func _change_camera_limit():
	camera_ccl = get_node_or_null("/root/WorldRoot/Player/CameraDirection/Camera2D")
	player_ccl = get_node_or_null("/root/WorldRoot/Player")
	current_scene_ccl = world_root_ccl.get_child(world_root_ccl.get_child_count()-1)
	roomsize_ccl = current_scene_ccl.get_node_or_null("RoomSizeReference")
	
	if camera_ccl != null and current_scene_ccl != null:
		# starting roomsize check
		if roomsize_ccl != null:
			print(roomsize_ccl.position)
			camera_ccl.limit_right = roomsize_ccl.position.x
			camera_ccl.limit_bottom = roomsize_ccl.position.y
		
		else:
			print("unable to find RoomSizeReference node, written by GlobalScript/_change_camera_limit")
			camera_ccl.limit_right = 10000000
			camera_ccl.limit_bottom = 10000000
			
	else:
		print("unable to find camera or current_scene node, written by GlobalScript/_change_camera_limit")
