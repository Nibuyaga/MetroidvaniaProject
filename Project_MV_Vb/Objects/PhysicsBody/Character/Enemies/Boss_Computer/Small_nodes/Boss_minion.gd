extends "res://Objects/PhysicsBody/Character/Character.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum STATE{
	detect,
	attack
}

var my_speed = 1500
var gravitybrake = 500
var state = STATE.detect
onready var PDR: RayCast2D = get_node("PlayerDetectRay")

export var face_left = false
export var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if face_left:
		$PlayerDetectRay.cast_to.x = $PlayerDetectRay.cast_to.x * -1
		my_speed = my_speed * -1	# changes the speed so it goes left
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match state:
		STATE.detect:
			if velocity.y <= 0:
				queue_free()
			
			if PDR.is_colliding():
				state = STATE.attack
				velocity = Vector2.ZERO
				gravity = 0

		
		STATE.attack:
			
			velocity += Vector2(my_speed*delta, 0)
			
			var collision = move_and_collide(velocity * delta)
			if collision:
				velocity.x = 0
				# velocity = velocity.slide(collision.normal)
				
				queue_free()
				
				
			if (
				(global_position.x <= -10000) 
				or (global_position.x >= 10000)
				):
				queue_free()



