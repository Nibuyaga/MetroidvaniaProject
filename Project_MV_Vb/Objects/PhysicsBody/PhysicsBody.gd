extends KinematicBody2D

export var gravity = 1000 # TODO: Get from scene
export var drag = 400
export var bounce = 0.2
export var minimum_move = 8

onready var floor_ray = get_node("FloorRay")
onready var wall_ray = get_node("WallRay")

var velocity = Vector2(0,0) 
var bounce_trigger_velocity = 128 # TODO: Better to be based on tile size

func _physics_process(delta):
	if is_on_floor():
		if velocity.y > bounce_trigger_velocity:
			velocity.y = -velocity.y*bounce
		elif velocity.y > 0:
			velocity.y = 0
	elif is_on_ceiling():
		if velocity.y < -bounce_trigger_velocity:
			velocity.y = -velocity.y/bounce
		elif velocity.y < 0:
			velocity.y = 0
	else:
		velocity.y += gravity*delta

	if is_on_wall():
		if abs(velocity.x) > bounce_trigger_velocity:
			velocity.x = -velocity.x/bounce
		else:
			velocity.x = 0

	move_and_slide(velocity, Vector2.UP)
	velocity.x /= 1+(drag*delta)
	if abs(velocity.x) < minimum_move: velocity.x = 0
