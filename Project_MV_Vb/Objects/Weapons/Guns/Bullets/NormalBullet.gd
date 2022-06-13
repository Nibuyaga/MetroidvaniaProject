extends Area2D
const vfx = preload("res://Objects/vfx.tscn")

var speed = 512

func _ready():
	position -= transform.y * 16

func destroy():
	var poof = vfx.instance()
	get_tree().get_root().add_child(poof)
	poof.get_node('animation').play('explosion_a')
	poof.position = self.position
	queue_free()

func _physics_process(delta):
	position -= transform.y * speed * delta
	if len(get_overlapping_bodies()) > 0:
		for body in get_overlapping_bodies():
			if "stats" in body:
				if body.stats["alive"]:
					destroy()
			else:
				destroy()
		
		$TDfunc.TD_multibodies(get_overlapping_bodies(), self)
		
		
		dqffunc()
	if position.x < -5000 or position.x > 5000:
		dqffunc()
	if position.y < -5000 or position.y > 5000:
		dqffunc()
	

func dqffunc():
	call_deferred("queue_free")
