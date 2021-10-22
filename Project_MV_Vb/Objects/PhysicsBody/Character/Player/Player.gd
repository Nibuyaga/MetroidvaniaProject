extends "res://Objects/PhysicsBody/Character/Character.gd"

var wall_jump_distance = 16 # relative to tile-size
var double_jump = 0
var wall_jump = 0
var jumping = false

var facing = 0
var aim = 0 # multiply by 45 degrees 

export var double_jumps = 1
export var wall_jumps = 3
export var wall_jump_force = 512

onready var arm = get_node("arm")
onready var weapons = [get_node("arm/gun_normal"), get_node("arm/gun_grenade"), get_node("arm/gun_hook")]
export var current_weapon = 0


# var for GUI
onready var GUI =  get_node_or_null("CanvasLayer/GUI")


func _ready():
	# used for setting player position when changing scenes
	if PlayerVariables.player_spawn_location != null:
		global_position = PlayerVariables.player_spawn_location
	
		PlayerVariables.get_data(self)
	
	# !AT, sets the AnimationTree at active at ready
	$AnimationTree.active = true

func _input(event):
	# input for falling through 'pass' tiles
	if event.is_action_pressed("aim_down") and $FloorRay.is_colliding():
		velocity.y += 1
	


func update_aim():
	var manual_aim_up = Input.get_action_strength("aim_up_right") - Input.get_action_strength("aim_up_left")
	var manual_aim_down = Input.get_action_strength("aim_down_right") - Input.get_action_strength("aim_down_left")
	var auto_aim = Input.get_action_strength("aim_up") - Input.get_action_strength("aim_down")
	if manual_aim_up:
		aim = int(manual_aim_up)
	elif manual_aim_down:
		aim = int(manual_aim_down)
	# If not manually aiming, figure it out with up and down.
	else: 
		if facing:
			aim = round(facing)*2
			if aim < 0:
				aim += auto_aim
			elif aim > 0:
				aim -= auto_aim
		elif auto_aim:
			aim = (auto_aim-1)*2
	aim = int(aim+8)%8
	arm.rotation = deg2rad(aim*45)
	arm.apply_scale(Vector2(1,1))

func jump():
	if not jumping:
		var space_state = get_world_2d().direct_space_state
		var to = global_position + Vector2(facing * wall_jump_distance, 0)
		var wall_ray_results = space_state.intersect_ray(global_position, to, [self])
		if is_on_floor():
			pass
		elif len(wall_ray_results) > 0 and wall_jump < wall_jumps:
			wall_jump += 1
			velocity.x -= (facing * wall_jump_force)
		elif double_jump < double_jumps:
			double_jump += 1
		else:
			return
		jumping = true
		velocity.y = -jumpforce

func _process(delta):
	facing = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x += speed * facing * delta
	if is_on_floor():
		double_jump = 0
		wall_jump = 0
	if Input.is_action_pressed('jump'):
		jump()
	else:
		jumping = false
	update_aim()
	weapons[current_weapon].update_weapon(delta, aim, Input.get_action_strength("attack_a"))
	
	
	
	# !Camera and Blendspace2D.x correction
	if facing != 0:
		$CameraDirection.position.x = facing * 20
		
		# !AT, not optimal
		# Also PhysicBody's _physics_process() still applies flip.h 
		$AnimationTree.set("parameters/Idle/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/Run/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/GroundAttack_1_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/GroundAttack_2_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/JumpNormal/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/JumpAttack_1_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/JumpAttack_2_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/Crouch/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/CrouchAttack_1_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/CroundAttack_2_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/Damaged_BlendSpace2D/blend_position", Vector2(facing, 0))
		$AnimationTree.set("parameters/Dead_BlendSpace2D/blend_position", Vector2(facing, 0))
		
	
	# !AT, animationtree section
	if $FloorRay.is_colliding():
		# Ground Animation
		$AnimationTree.set("parameters/Stance/current", 1)

	else:
		# Jump Animation
		$AnimationTree.set("parameters/Stance/current", 0)

# note by nib, can be helpful when implementing AnimationTree
# $AnimationTree.set("parameters/Idle/blend_position", Vector2(0,0))
# "parameters/GroundAttack_1_BlendSpace2D/blend_position"


# The player's Hurtbox function overwrites the Character function, fully
func _on_Hurtbox_area_entered(area):
	if area.position.x > position.x:
		knockback(Vector2(-1000,-100))
	else:
		knockback(Vector2(1000,-100))
	
	
	if "damage" in area:	# This needs to be tested
		calc_health(area.damage)
	else:
		calc_health(1)
	
	
	# GUI function, may need to change if the GUI is placed somewhere else
	if GUI != null:
		GUI.update_bars("hp", health)
