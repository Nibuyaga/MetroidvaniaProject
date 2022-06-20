extends KinematicBody2D

enum STATE {
	detect,
	prepare,
	shoot
}

signal enemyFound
signal shotFired

export var prepare_playrate = 1.0
export var shoot_playrate = 1.0

var state = STATE.detect
onready var RC: RayCast2D = get_node("RayCast2D")
onready var RCD: RayCast2D = get_node("RayCastDetect")

export var damage = 2


func _physics_process(_delta):
	
	# Ray2D stuff
	var cast_point := RC.cast_to
	RC.force_raycast_update()
	
	if RC.is_colliding():
		# collide with player or enemy

		# When the Raycast hits the world layer
			# collision with the tilemap etc
		cast_point = to_local(RC.get_collision_point())
	
	# Changes the cast_point in the respective state
	match state:
		STATE.detect:
			RCD.cast_to = cast_point
			$DetectionLine.points[1] = cast_point
			$DetectionLine.points[1].y += 3	#correction
			RCD.force_raycast_update()
			if RCD.is_colliding():
				change_to_prepare()
				emit_signal("enemyFound")
			
		STATE.shoot:
			$Laser.points[1] = cast_point
			$Laser.points[1].y += 3	#correction
			$LaserHitbox/CollisionShape2D.shape.height = cast_point.y
			$LaserHitbox/CollisionShape2D.position.y = cast_point.y/2
	

func change_to_detect():
	state = STATE.detect
	$AnimationPlayer.playback_speed = 1
	emit_signal("shotFired")
	$AnimationPlayer.play("detect_appear")

func change_to_prepare():
	state = STATE.prepare
	$DetectionLine.visible = false
	$AnimationPlayer.playback_speed = prepare_playrate
	$AnimationPlayer.play("prepare")

func change_to_shoot():
	state = STATE.shoot
	$AnimationPlayer.playback_speed = shoot_playrate
	$AnimationPlayer.play("shoot")




# tween functions !Unused
#func laser_appear():
#	$Tween.stop_all()
#	$Tween.interpolate_property($Laser, "width", 0, 10, 0.1)
#	$Tween.start()
#
#func laser_disappear():
#	$Tween.stop_all()
#	$Tween.interpolate_property($Laser, "width", 10, 0, 0.1)
#	$Tween.start()
#
#func detect_appear():
#	$Tween.stop_all()
#	$Tween.interpolate_property($DetectionLine, "width", 0, 10, 0.1)
#	$Tween.start()
#
#func detect_disappear():
#	$Tween.stop_all()
#	$Tween.interpolate_property($DetectionLine, "width", 10, 0, 0.1)
#	$Tween.start()
