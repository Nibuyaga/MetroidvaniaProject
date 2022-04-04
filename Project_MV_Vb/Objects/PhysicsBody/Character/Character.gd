extends "res://Objects/PhysicsBody/PhysicsBody.gd"

export var speed = 2400
export var jumpforce = 380
export var stats = {
	'gun':0,
	'health':10,
	'max_health':10,
	'alive': true,
}

var facing = 0
var is_jumping = false


# Default jump function, overwrite in subclasses
func jump():
	is_jumping = true
	velocity.y = -jumpforce

func knockback(force=Vector2(0,0), relative=false):
	if relative:
		force.x *= facing
	velocity += force

func _on_Hurtbox_area_entered(area):
	print('whaa')
	if not stats['alive']:
		return
	if area.position.x > position.x:
		knockback(Vector2(-1000,-100))
	else:
		knockback(Vector2(1000,-100))

	if "damage" in area:	# This needs to be tested
		calc_health(area.damage)
	else:
		calc_health(1)


func calc_health(damage):
	if stats['alive']:
		stats['health'] -= damage
		if stats['health'] <= 0:
			die()
		else:
			$AnimationPlayer.play("hurt")

func die():
	stats['alive'] = false
	if get_node_or_null("AnimationPlayer") == null:
		print("Object removed")
		self.queue_free()
	else:
		$AnimationPlayer.play("die")

func at_dead_queue_free():
	queue_free()
