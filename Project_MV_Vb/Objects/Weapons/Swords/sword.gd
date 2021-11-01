extends Area2D

export var cooldown = 0.15
var cooldown_timer = 0
var slash_time = 0.1
var slash_timer = 0
onready var player = get_node("../")
var charging = false
var charge = 0


func update_weapon(delta, aim, attack):
	scale.x = player.facing
	cooldown_timer -= delta
	if cooldown_timer < 0 and attack:
		cooldown_timer = cooldown
		charging = true
		charge = 0
		$swoosh.show()
	if charging:
		if attack:
			$swoosh.frame = 1
			charge += delta
		else:
			charging = false
			$swoosh.frame = 0
			slash_timer = slash_time
			if player.velocity.y < 5:
				player.knockback(Vector2(500,-10), true)
	if slash_timer > 0:
		slash_timer -= delta
		$sword_shape.disabled = false
	else:
		$sword_shape.disabled = true
		if not charging:
			$swoosh.hide()
