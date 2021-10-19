extends "res://Objects/PhysicsBody/PhysicsBody.gd"

export var speed = 3200
export var jumpforce = 500
export var health = 10

var is_jumping = false
var is_alive = true


# Default jump function, overwrite in subclasses
func jump():
	is_jumping = true
	velocity.y = -jumpforce

func knockback(force=Vector2(0,0)):
	velocity += force

func _on_Hurtbox_area_entered(area):
	if area.position.x > position.x:
		knockback(Vector2(-1000,-100))
	else:
		knockback(Vector2(1000,-100))

	if "damage" in area:	# This needs to be tested
		calc_health(area.damage)
	else:
		calc_health(1)

func calc_health(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	if get_node_or_null("AnimationPlayer") == null:
		print("Object removed")
		self.queue_free()
	else:
		$AnimationPlayer.play("Dying")

func at_dead_queue_free():
	queue_free()
