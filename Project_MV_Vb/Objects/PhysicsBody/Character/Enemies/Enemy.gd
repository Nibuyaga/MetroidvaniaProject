extends "res://Objects/PhysicsBody/Character/Character.gd"

export var persistent = true
export var jumper = true
export var flyer = true
export var jump_time = 1
var jump_timer = jump_time

func _ready():
	$AnimationPlayer.play("move")
	facing = 1
	$FloorRay.position.x = 8 # Does this depend on sprite size?

func turn_around():
	facing = -facing
	$FloorRay.position.x = -$FloorRay.position.x

func hurt():
	if stats['health'] <= 0:
		$AnimationPlayer.play("die")
	else:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("hurt")

func _process(delta):
	$Health_Counter.set_health(stats['health'])
	if flyer and not jumper and stats['alive']:
		velocity.y = 0.0
	if stats['health'] <= 0:
		return 
	# turn if standing still (only works directly after _physics_process)
	if $WallRay.is_colliding():
		turn_around()
	elif is_on_floor() and not $FloorRay.is_colliding() and not persistent and not jumper:
		turn_around()
	# jump if on floor and timer is down
	elif $FloorRay.is_colliding() and jumper:
		if not is_jumping:
			$AnimationPlayer.play("jump")
			jump()
		else:
			if jump_timer < 0:
				is_jumping = false
				jump_timer = jump_time
	jump_timer -= delta
	
	velocity.x = speed*self.facing
