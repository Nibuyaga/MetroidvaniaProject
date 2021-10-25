extends Node2D

export var cooldown = 1
var cooldown_timer = 0

onready var player = get_node("../../")

func slash():
	player.knockback(Vector2(1000,100))

func update_weapon(delta, aim, attack):
	cooldown_timer -= delta
	if cooldown_timer > 0:
		return
	if attack:
		cooldown_timer = cooldown
		slash()
