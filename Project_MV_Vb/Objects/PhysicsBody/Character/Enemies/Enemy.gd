extends "res://Objects/PhysicsBody/Character/Character.gd"

export var go_right = true
export var persistent = true
export var jumper = true
export var jump_time = 1
var jump_timer = jump_time

func _ready():
	$FloorRay.position.x = 8 # Does this depend on sprite size?

func turn_around():
	go_right = not go_right
	$FloorRay.position.x = -$FloorRay.position.x

func _process(delta):
	# turn if standing still (only works directly after _physics_process)
	if not abs(velocity.x) > 0:
		turn_around()
	# turn if not on floor next step
	elif not $FloorRay.is_colliding() and not persistent and not jumper:
		turn_around()
	# jump if on floor and timer is down
	elif $FloorRay.is_colliding() and jumper:
		if not is_jumping:
			$AnimationPlayer.play("Jump")
			jump()
		else:
			if jump_timer < 0:
				is_jumping = false
				jump_timer = jump_time
	jump_timer -= delta
	
	if go_right:
		velocity.x = speed
	else:
		velocity.x = -speed
	$Health_Counter.set_health(health)
