extends Area2D


# Declare member variables here. Examples:
export var timer = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
	
	# Tile destruction
	if len(get_overlapping_bodies()) > 0:
		$TDfunc.TD_multibodies(get_overlapping_bodies(), self)
