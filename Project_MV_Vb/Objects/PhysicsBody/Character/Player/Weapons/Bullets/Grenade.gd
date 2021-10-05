extends "res://Objects/PhysicsBody/PhysicsBody.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 5
export var speed = 500

func explode():
	pass #print('boom')


# Called when the node enters the scene tree for the first time.
func _ready():
	position -= transform.y * 64
	velocity.x = speed

func _process(delta):
	time -= delta
	if time <= 0 or len($Hitbox.get_overlapping_areas()) > 0:
		explode()
