extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var start_room = 'Rooms/Test_Room.tscn'
var current_room = null


func swap_scene(scene_path='Rooms/Test_Room.tscn'):
	if current_room:
		current_room.queue_free()
	var new_room = load(scene_path)
	current_room = new_room.instance()
	get_tree().current_scene.add_child(current_room)
	print_tree()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	swap_scene(start_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
