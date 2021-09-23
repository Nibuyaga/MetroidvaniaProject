extends KinematicBody2D


var move = Vector2(0,0)


export var speed = 2000
export var gravity = 1500
export var jump_strength = -1000


export var health = 8
var death_check = true	# variable to prevent repeating death animation

var jump_check = true


func _ready():
	calc_health(0)


func _process(delta):
	
	move.y += gravity * delta
	
	move = move_and_slide(move, Vector2.UP)
	
	if is_on_floor() and jump_check:
		$AnimationPlayer.play("Jump")
		jump_check = false


# whenever the player hitbox enters the objects hurtbox
func _on_Hurtbox_area_entered(area):
	if "damage" in area:	# This needs to be tested
		calc_health(area.damage)
	else:
		calc_health(1)


# damage functions
func calc_health(damage):
	health -= damage
	$Enemy_Health_Counter.set_health(health)	# remove or comment when health_counter is unneccesary
	
	if health <= 0 and death_check:
		death_check = false
		dying()


func jump():
	move.y = jump_strength
	jump_check = true


func dying():
	jump_check = false
	$AnimationPlayer.play("Dying")
