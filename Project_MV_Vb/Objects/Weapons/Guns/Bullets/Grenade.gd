extends "res://Objects/PhysicsBody/PhysicsBody.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Explosion = preload("GrenadeExplosion.tscn")

var time = 2
export var speed = 256

func explode():
	var explosion = Explosion.instance()
	explosion.position = global_position
	Global.grab_current_level().add_child(explosion)
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	position -= transform.y * 32
	velocity.x = speed

func _process(delta):
	time -= delta
	if time <= 0 or len($Hitbox.get_overlapping_areas()) > 0:
		explode()
