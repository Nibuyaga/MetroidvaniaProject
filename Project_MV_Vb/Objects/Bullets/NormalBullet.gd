extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 512

# Called when the node enters the scene tree for the first time.
func _ready():
	position -= transform.y * 16

func _physics_process(delta):
	position -= transform.y * speed * delta
	if len(get_overlapping_bodies()) > 0:
		queue_free()
	if position.x < -5000 or position.x > 5000:
		queue_free()
	if position.y < -5000 or position.y > 5000:
		queue_free()
	
