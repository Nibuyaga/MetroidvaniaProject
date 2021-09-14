extends KinematicBody2D


var move = Vector2(0,0)
export var Speed = 180
export var Gravity = 10
export var JumpForce = -500

func _physics_process(delta):
	
	
	move.x = Speed * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	move.y += Gravity
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		move.y = JumpForce
	
	move = move_and_slide(move, Vector2.UP)
	
	move.x = lerp(move.x, 0, 0.2)
