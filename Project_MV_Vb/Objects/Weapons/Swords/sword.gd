extends Area2D

export var cooldown = 0.15
var cooldown_timer = 0
var slash_time = 0.05
var slash_timer = 0
onready var player = get_node("../")

func update_weapon(delta, aim, attack):
	cooldown_timer -= delta
	if cooldown_timer < 0 and attack:
		cooldown_timer = cooldown
		slash_timer = slash_time
		if player.velocity.y < 5:
			player.knockback(Vector2(500,-10), true)
	if slash_timer > 0:
		slash_timer -= delta
		scale.x = player.facing
		$sword_shape.disabled = false
		$swoosh.show() # play animation instead
	else:
		$sword_shape.disabled = true
		$swoosh.hide()
