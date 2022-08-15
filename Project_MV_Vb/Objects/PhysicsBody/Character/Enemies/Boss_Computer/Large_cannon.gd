extends Node2D


var playerseen = false
onready var playernode = Global.grab_current_level().get_node_or_null("Player")
export var rotation_correction = 0.25	# 1 = full rotation, 0.5 = half rotation, etc.
var activated = false

export var rotation_speed = 1
var target_rotation = 0

export var timer_detect = 3
var timer_detect_script = timer_detect
export var timer_prepare = 1
var timer_prepare_script = timer_prepare
export var timer_shoot = 2
var timer_shoot_script = timer_shoot

onready var RC: RayCast2D = get_node("RayCast2D")

signal shotfired

enum STATE {
	detect,
	prepare,
	shoot
}
var state = STATE.detect


func _ready():
	if playernode != null:
		playerseen = true


func _process(delta):
	
	if playerseen and activated:
	
		match state:
			STATE.detect:
				update_aim_to_player(delta)
				timer_detect_script -= delta
				if timer_detect_script <= 0:
					state = STATE.prepare
					prepare_laser()
					timer_detect_script = timer_detect
			
			STATE.prepare:
				pass	# is unused
			
			STATE.shoot:
				timer_shoot_script -= delta
				if timer_shoot_script <= 0:
					laser_off()
					timer_shoot_script = timer_shoot
					deactivate_cannon()
					emit_signal("shotfired")




func update_aim_to_player(delta):
	var sum_vector = global_position - playernode.global_position
	target_rotation = atan2(sum_vector.y, sum_vector.x) + (2 * PI * rotation_correction)

	if target_rotation != rotation:
		if target_rotation > rotation:
			if (target_rotation - rotation) < rotation_speed * delta:
				rotation += (target_rotation - rotation)
			else:
				rotation += rotation_speed * delta
		elif target_rotation < rotation:
			if (rotation - target_rotation) < rotation_speed * delta:
				rotation -= (rotation - target_rotation)
			else:
				rotation -= rotation_speed * delta

func prepare_laser():
	# makes it visible
	$PrepareSprite.visible = true
	
	# changes the size
	$Tween1.interpolate_property(
		$PrepareSprite,
		"scale",
		Vector2(3,3),	# original size
		Vector2(0,0),	# end size
		timer_prepare_script,	# animation length in seconds
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
		)
	$Tween1.start()
	
	# changes the position
	$Tween2.interpolate_property(
		$PrepareSprite,
		"position",
		Vector2(0,60),	# original size
		Vector2(0,30),	# end size
		timer_prepare_script,	# animation length in seconds
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
		)
	$Tween2.start()

func _on_Tween_tween_completed(object, key):
	# When it finishes the prepare animation
	if object == $PrepareSprite and "position" in str(key):
		state = STATE.shoot
		update_laser()
		laser_on()
		$PrepareSprite.visible = false

func update_laser():
	# Ray2D stuff
	var cast_point := RC.cast_to
	RC.force_raycast_update()
	
	if RC.is_colliding():
		# When the Raycast hits the world layer
			# collision with the tilemap etc
		cast_point = to_local(RC.get_collision_point())
	
	# updates the length of the hitbox and sprite length
	$Laser_Hitbox.position.y = cast_point.y/2
	$Laser_Hitbox/Laser.scale.y = cast_point.y/20 + 2
	$Laser_Hitbox/CollisionShape2D.shape.height = cast_point.y
	# note: laser.sprite = 20 pixel high, Cshape = 40, assume 20 as offset

func laser_on():
	$Laser_Hitbox.visible = true
	$Laser_Hitbox/CollisionShape2D.set_deferred("disabled", false)

func laser_off():
	$Laser_Hitbox.visible = false
	$Laser_Hitbox/CollisionShape2D.set_deferred("disabled", true)

func activate_cannon():
	activated = true
	visible = true
	state = STATE.detect

func deactivate_cannon():
	activated = false
	visible = false
	state = STATE.detect

