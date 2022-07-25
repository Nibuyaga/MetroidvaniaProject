extends Area2D

var active_bool = false
export var active_time = 3.0
var timerz = 0.0

func _ready():
	pass

func activate_sword_hitbox(hitboxPosition=Vector2.ZERO):
	$CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	$CollisionShape2D.position = hitboxPosition
	active_bool = true
	timerz = active_time
	$TDfunc.onetime = true	# is for tile destruction


func deactivate_sword_hitbox():
	$CollisionShape2D.disabled = true



func _physics_process(delta):

	# Simple timer
	if active_bool:
		timerz -= delta
		# When the timer end
		if timerz <= 0:
			active_bool = false
			deactivate_sword_hitbox()

	if len(get_overlapping_bodies()) > 0:
		$TDfunc.TD_multibodies(get_overlapping_bodies(), $CollisionShape2D)
