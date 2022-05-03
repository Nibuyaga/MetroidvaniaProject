extends "res://Objects/PhysicsBody/Character/Character.gd"


# TODO: https://docs.godotengine.org/en/3.1/getting_started/step_by_step/singletons_autoload.html
var horizontal_movement = 0
var wall_jump_distance = 16 # relative to tile-size
var double_jump = 0
var wall_jump = 0
var jumping = false

var aim = 0 # multiply by 45 degrees 

export var double_jumps = 1
export var wall_jumps = 2
export var wall_jump_force = 128

onready var player_vars = get_node("/root/PlayerVariables")
onready var arm = get_node("arm")
#onready var sword = get_node("sword")
onready var guns = [get_node("arm/gun_normal"), get_node("arm/gun_grenade"), get_node("arm/gun_hook")]
#export var gun = 0

# var for HUD
onready var HUD =  get_node_or_null("CanvasLayer/HUD_simple")


func _ready():
	# used for setting player position when changing scenes
	if PlayerVariables.player_spawn_location != null:
		global_position = PlayerVariables.player_spawn_location
	
		PlayerVariables.get_data(self)
	
	# gets stored playervariables
	if PlayerVariables.gameplay_is_running:
		PlayerVariables.get_data(self)
	
	HUD.update_multiple_at_ready(stats)
	# !AT, sets the AnimationTree at active at ready
	$AnimationTree.active = true

func _input(event):
	# input for falling through 'pass' tiles
	if event.is_action_pressed("aim_down") and $FloorRay.is_colliding():
		velocity.y += 1
	# input for cycling through bullets
	elif event.is_action_pressed("cycle_bullet"):
		stats["gun"] += 1
		if stats["gun"] >= stats["gun_max_cycle"]:
			stats["gun"] = 0

		HUD.updateBulletIcon(stats["gun"])

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
		if horizontal_movement:
			aim = round(horizontal_movement)*2
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
	horizontal_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if horizontal_movement:
		facing = horizontal_movement
		velocity.x += speed * facing * delta
	if is_on_floor():
		double_jump = 0
		wall_jump = 0
	if Input.is_action_pressed('jump'):
		jump()
	else:
		jumping = false
	update_aim()
	#TODO: check if gun in player_vars.stats['guns']
	guns[stats["gun"]].update_weapon(delta, aim, Input.get_action_strength("attack_a"))
	#if 'sword' in player_vars.stats:
	#	sword.show()
	#	sword.update_weapon(delta, aim, Input.get_action_strength("attack_b"))
	#else:
	#	sword.hide()
		
	# !Camera and Blendspace2D.x correction
	$CameraDirection.position.x = facing * 20
	
	
	$AnimationTree.set("parameters/action/current", 1)
	if is_on_floor():
		if abs(velocity.x) > 0.01: 
			$AnimationTree.set("parameters/movement/current", 1)
		else:
			$AnimationTree.set("parameters/movement/current", 0)


# note by nib, can be helpful when implementing AnimationTree
# $AnimationTree.set("parameters/Idle/blend_position", Vector2(0,0))
# "parameters/GroundAttack_1_BlendSpace2D/blend_position"


# The player's Hurtbox function overwrites the Character function, fully
func _on_Hurtbox_area_entered(area):
	print('ouch!')
	knockback(Vector2(-1000,-100), true)
	
	if "damage" in area:	# This needs to be tested
		calc_health(area.damage)
	else:
		calc_health(1)
	
	# HUD function
	if HUD != null:
		HUD.update_hud("hp", stats['health'])
