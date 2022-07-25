extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var playerseen = false
onready var playernode = Global.grab_current_level().get_node_or_null("Player")
export var rotation_correction = 0.5	# 1 = full rotation, 0.5 = half rotation, etc.

export var timer = 3
var timerscript = timer

export var healthpoints = 3
var hp_script = healthpoints

export var respawntimer = 15
var r_timerscript = respawntimer
var downed = false

const bullet = preload("Enemy_Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if playernode != null:
		playerseen = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerseen and downed == false:
		
		
		timerscript -= delta
		if timerscript <= 0:	# When shooting
			update_aim_to_player()
			shoot_player()
			timerscript = timer
	
	elif downed == true:
		r_timerscript -= delta
		if r_timerscript <= 0:	# when respawning
			downed = false
			r_timerscript = respawntimer
			$Hurtbox.set_deferred("monitoring", true)
			$Sprite_cannon.visible = true
			# also resets gun cooldown
			timerscript = timer

func update_aim_to_player():
	var sum_vector = global_position - playernode.global_position
	rotation = atan2(sum_vector.y, sum_vector.x) + (2 * PI * rotation_correction)

func shoot_player():
	var bullet_in = bullet.instance()
	bullet_in.global_position = self.global_position
	bullet_in.rotation = self.rotation
	Global.grab_current_level().add_child(bullet_in)

func calc_health(damage):
	hp_script -= damage
	
	if hp_script <= 0:	# when downed
		downed = true
		hp_script = healthpoints
		$Hurtbox.set_deferred("monitoring", false)
		$Sprite_cannon.visible = false

func _on_Hurtbox_area_entered(area):
	if "damage" in area:
		calc_health(area.damage)
	else:
		calc_health(1)
