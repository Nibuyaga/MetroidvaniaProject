extends "res://Objects/PhysicsBody/PhysicsBody.gd"

export var speed = 6400
export var jumpforce = 500
export var health = 10

func _on_Hurtbox_area_entered(area):
	calc_health(1)

func calc_health(damage):
	health -= damage

func jump():
	if is_on_floor():
		velocity.y = jumpforce

func knockback(towards=Vector2(0,0)):
	velocity += towards
