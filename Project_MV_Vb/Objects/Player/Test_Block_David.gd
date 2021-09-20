extends KinematicBody2D

var move = Vector2(0,0)
var drag = 0.1
var minimum_move = 5

export var Speed = 1000
export var Gravity = 10
export var JumpForce = -500
export var AirJumps = 1
export var WallJumps = 3
export var WallJumpForce = -250

var wall_jump_distance = 8 # Is relatief aan tile-size
var air_jump = 0
var wall_jump = 0

onready var drop_check = get_node("Drop_Down_Check")

func _input(event):
#	input om door de "pass" tiles te vallen
	if event.is_action_pressed("ui_down") and drop_check.is_colliding():
		position.y += 1

func jump(detla, intention):
	if is_on_floor():
		air_jump = 0
		wall_jump = 0
	if Input.is_action_just_pressed("ui_up"): 
		var space_state = get_world_2d().direct_space_state
		var to = global_position + Vector2(intention * wall_jump_distance, 0)
		var wall_ray_results = space_state.intersect_ray(global_position, to, [self])
		if is_on_floor():
			pass
		elif len(wall_ray_results) > 0 and wall_jump < WallJumps:
			wall_jump += 1
			move.x += (intention * WallJumpForce)
		elif air_jump < AirJumps:
			air_jump += 1
		else:
			return
		move.y = JumpForce

func _physics_process(delta):
	var intention = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move.x += (Speed * intention) * delta
	move.y += Gravity
	move = move_and_slide(move, Vector2.UP)
	jump(delta, intention)
	move.x /= 1+drag
	if abs(move.x) < minimum_move: move.x = 0
