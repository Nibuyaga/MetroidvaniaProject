extends StaticBody2D


export var health = 10
var health_script = health

export var reboot_timer = 5
var reboot_timer_script = reboot_timer
var reboot_process = false

signal shieldDown
signal shieldUp


func _process(delta):
	if reboot_process:
		reboot_timer_script -= delta
		if reboot_timer_script <= 0:
			shield_up()


func shield_down():
	# handling the timer
	reboot_timer_script = reboot_timer
	reboot_process = true
	
	# handling the collisions and the sprite
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("shieldDown")

func shield_up():
	# handling the timer
	reboot_process = false
	
	# handling health
	health_script = health
	
	# handling the collisions and sprite
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	emit_signal("shieldUp")

func _on_Hurtbox_area_entered(area):
	if "damage" in area:
		health_script -= area.damage
	else:
		health_script -= 1
	
	if health_script <= 0:
		shield_down()
