extends "res://Objects/PhysicsBody/PhysicsBody.gd"

export var speed = 2400
export var jumpforce = 380
export var stats = {
	'gun':0,
	'gun_max_cycle': 3,
	'max_health':10,
	'health':10,
	'alive': true,
	
}
export var invincibility = 0
var invi_timer = 0

var damage_invincibility = false
var facing = 0
var is_jumping = false

#may need expanding if wanting to use status
var envi_damage = {
	"state": false	,
	"damage tick": 1,
	"cooldown set": 1,
	"cooldown current": 0
}

func _process(delta):
	
	
	# invincibility timer
	if damage_invincibility:
		invi_timer -= delta
		if invi_timer <= invincibility:
			damage_invincibility = false
	
	# environment damage
	if envi_damage["state"] or envi_damage["cooldown current"] > 0:
		envi_handling(delta)

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

	if "damage" in area:
		calc_health(area.damage)
	else:
		calc_health(1)


func _on_Hurtbox__Environment_body_entered(_body):
	envi_damage["state"] = true

func _on_Hurtbox__Environment_body_exited(_body):
	envi_damage["state"] = false

func envi_handling(delta):
	if envi_damage["state"] == true:
		if envi_damage["cooldown current"] <= 0:
			calc_health(envi_damage["damage tick"])
			envi_damage["cooldown current"] = envi_damage["cooldown set"]
		else:
			envi_damage["cooldown current"] -= delta
	else:
		envi_damage["cooldown current"] -= delta

#var envi_damage = {
#	"state": false	,
#	"damage tick": 1,
#	"cooldown set": 1,
#	"cooldown current": 0
#}

func calc_health(damage, animation = true):
	if stats['alive']:
		stats['health'] -= damage
		print(self.name + "'s health: " + str(stats["health"]))
		if stats['health'] <= 0:
			die()
		elif animation:
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

