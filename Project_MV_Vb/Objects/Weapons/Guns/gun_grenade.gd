extends Node2D


const Grenade = preload("Bullets/Grenade.tscn")

export var Rate = 0.5 # time in in seconds
export var Cooldown = 0

func update_weapon(delta, aim, attack=false):
	Cooldown -= delta
	if Cooldown > 0:
		return
	if attack != 0:
		Cooldown = Rate
		var bullet = Grenade.instance()
		bullet.position = global_position
		bullet.rotation_degrees = aim*45
		Global.grab_current_level().add_child(bullet)
		bullet.velocity = bullet.velocity.rotated(deg2rad((aim-2)*45))
