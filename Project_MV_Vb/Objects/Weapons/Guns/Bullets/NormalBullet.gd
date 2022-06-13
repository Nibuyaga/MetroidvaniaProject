extends Area2D


var speed = 512

func _ready():
	position -= transform.y * 16

func _physics_process(delta):
	position -= transform.y * speed * delta
	if len(get_overlapping_bodies()) > 0:
		
		$TDfunc.TD_multibodies(get_overlapping_bodies(), self)
		
		
		dqffunc()
	if position.x < -5000 or position.x > 5000:
		dqffunc()
	if position.y < -5000 or position.y > 5000:
		dqffunc()
	

func dqffunc():
	call_deferred("queue_free")
