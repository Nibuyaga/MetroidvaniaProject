extends KinematicBody2D

# add animationplayer
# 
enum STATE {
	detect,
	prepare,
	shoot
}

var state = STATE.shoot
onready var RC: RayCast2D = get_node("RayCast2D")

func _physics_process(_delta):
	
	# Ray2D stuff
	var cast_point := RC.cast_to
	RC.force_raycast_update()
	
	if RC.is_colliding():
		# collide with player or enemy
		if RC.get_collision_mask_bit(10) or RC.get_collision_mask_bit(11):
			change_to_prepare()
		# When the Raycast hits the world layer
			# collision with the tilemap etc
		if RC.get_collision_mask_bit(0):
			cast_point = to_local(RC.get_collision_point())
	
	# Changes the cast_point in the respective state
	match state:
		STATE.detect:
			$DetectionLine.points[1] = cast_point
		STATE.shoot:
			$Laser.points[1] = cast_point


func change_to_prepare():
	state = STATE.prepare
	$DetectionLine.visible = false
