extends Node2D



export var start_room = 'Rooms/Test_Room.tscn'
var current_room = null


#	added a "call_deferred" to the swap_scene

func swap_scene(scene_path='Rooms/Test_Room.tscn'):
	call_deferred("_deferred_swap_scene", scene_path)

func _deferred_swap_scene(scene_path='Rooms/Test_Room.tscn'):
	if current_room:
		current_room.queue_free()
	var new_room = load(scene_path)
	current_room = new_room.instance()
	get_tree().current_scene.add_child(current_room)
	
	Global._change_camera_limit()
	
#	Commented print_tree() to prevent output overflow
#	print_tree()



# Called when the node enters the scene tree for the first time.
func _ready():
	
	swap_scene(start_room)
	


