extends "res://Objects/PhysicsBody/Character/Character.gd"


const projectile = preload("res://Objects/PhysicsBody/Character/Enemies/Boss-SlugTank/Projectile_SlugTank.tscn")


export var projectile_speed = 1000
export var cooldown_player_detection = 3

onready var player = null
onready var player_detection = cooldown_player_detection

func _ready():
	pass


func _process(delta):
	if player != null:
		
		# Timer
		player_detection -= delta
		
		if player_detection <= 0:
			# Reset timer
			player_detection = cooldown_player_detection
			
			# bunch of prints for information gathering
			print(player.global_position - global_position)
			print($Sprite/Cannon_Anchor.rotation_degrees)
			shoot_projectile()

func aim():
	
	# rotation degrees preferably between 0 and 90
	$Sprite/Cannon_Anchor.rotation_degrees = 45
	pass

func shoot_projectile():
	
	var new_pro = projectile.instance()
	new_pro.velocity = Vector2(
		cos(deg2rad($Sprite/Cannon_Anchor.rotation_degrees)) * -projectile_speed,
		sin(deg2rad($Sprite/Cannon_Anchor.rotation_degrees)) * -projectile_speed
		)
	new_pro.position = Vector2(
		$Sprite/Cannon_Anchor/Projectile_Ref.global_position.x,
		$Sprite/Cannon_Anchor/Projectile_Ref.global_position.y
		)
	
	
	Global.grab_current_level().add_child(new_pro)


func _input(event):
	if event.is_action_pressed("attack_b"):
		shoot_projectile()

func _on_Detection_Player_body_entered(body):
	player = body
