extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 20
var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = transform.x * speed
	var collisioninfo = move_and_collide(velocity * delta)
	
	if collisioninfo:
		# !spaghetti code, "kinda" copy pasted from the Player scene
		if collisioninfo.collider.name == "Player":
			
			collisioninfo.collider.knockback(Vector2(-1000,-100), true)
			collisioninfo.collider.calc_health(1)
		queue_free()
	
	
	if global_position.x >= 5000 or global_position.x <= -5000:
		queue_free()
	elif global_position.y >= 5000 or global_position.y <= -5000:
		queue_free()
	
