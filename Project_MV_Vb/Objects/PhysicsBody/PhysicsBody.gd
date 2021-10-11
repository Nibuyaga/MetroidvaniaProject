extends KinematicBody2D

export var gravity = 1000 # TODO: Get from scene
export var drag = 10
export var bounce = 0.2
export var minimum_move = 8

export var air_drag = 0.5
var flying = false
var floating = 1

var velocity = Vector2(0,0) 
var bounce_trigger_velocity = 128 # TODO: Better to be based on tile size

func _physics_process(delta):
	if is_on_floor():
		if velocity.y > bounce_trigger_velocity:
			velocity.y = -velocity.y*bounce
		elif velocity.y > 0:
			velocity.y = 0
	elif is_on_ceiling():
		if velocity.y < minimum_move:
			velocity.y = 0
	# Further X axis calculation -after- applying
	# so any initial movement is applied 
	move_and_slide(velocity, Vector2.UP)
	if is_on_wall():
		if abs(velocity.x) > 0:
			velocity.x = 0
	
	
	if is_on_floor():
		velocity.x /= 1+(drag*delta)
	else:
		velocity.x /= 1+((drag/air_drag)*delta)

	if not flying:
		velocity.y += gravity*floating*delta

	if abs(velocity.x) < minimum_move: velocity.x = 0

	if velocity.x > 0:
		$Sprite.flip_h = false
	elif velocity.x < 0:
		$Sprite.flip_h = true
