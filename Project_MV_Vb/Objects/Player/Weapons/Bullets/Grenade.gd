extends KinematicBody2D


var speed = 512

func _ready():
	position -= transform.y * 16

func _physics_process(delta):
	move_and_slide(Vector2(0,0))
	if position.x < -5000 or position.x > 5000:
		queue_free()
	if position.y < -5000 or position.y > 5000:
		queue_free()


