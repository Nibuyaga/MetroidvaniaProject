extends Area2D
const vfx = preload("res://Objects/vfx.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 512

# Called when the node enters the scene tree for the first time.
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
	if position.x < -5000 or position.x > 5000:
		queue_free()
	if position.y < -5000 or position.y > 5000:
		queue_free()
	
