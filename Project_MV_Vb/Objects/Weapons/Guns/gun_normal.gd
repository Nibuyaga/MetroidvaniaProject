extends Node2D


const NormalBullet = preload("Bullets/NormalBullet.tscn")

export var Rate = 0.1 # time in in seconds
var Cooldown = 0

func update_weapon(delta, aim, attack=false):
	Cooldown -= delta
	if Cooldown > 0:
		return
	if attack != 0:
		Cooldown = Rate
		var bullet = NormalBullet.instance()
		bullet.position = global_position
		bullet.rotation_degrees = aim*45
		get_tree().current_scene.add_child(bullet)
