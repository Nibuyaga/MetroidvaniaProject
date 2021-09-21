extends KinematicBody2D


var move = Vector2(0,0)

export var speed = 2000
export var gravity = 100
export var go_right = false	# determines whether the object moves left or right


export var health = 8
var single_time = true	# variable to prevent repeating death animation

func _ready():
#	a small convenience to flip the sprite also if the go_right is true
	if go_right:
		$Sprite.flip_h = true
		


func _process(delta):
	
#	Movement
	if go_right:
		move.x = speed * delta
	else:
		move.x = -speed * delta
	
	move.y += gravity * delta
	
	move = move_and_slide(move, Vector2.UP)
	
	
#	flips the object when getting obstructed
	if abs(move.x) < (speed * delta - 10 * delta):
		go_right = not go_right
		$Sprite.flip_h = not $Sprite.flip_h




# whenever the player hitbox enters the objects hurtbox
func _on_Hurtbox_area_entered(area):
	calc_health(1)


# damage functions
func calc_health(damage):
	health -= damage
	$Enemy_Health_Counter.set_health(health)
	
	if health <= 0 and single_time:
		single_time = false
		$AnimationPlayer.play("Dying")


# for the dying animation
func at_dead_queue_free():
	queue_free()
