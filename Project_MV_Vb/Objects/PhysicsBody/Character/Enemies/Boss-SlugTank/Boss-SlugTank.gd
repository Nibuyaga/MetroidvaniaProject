extends "res://Objects/PhysicsBody/Character/Character.gd"


const projectile = preload("res://Objects/PhysicsBody/Character/Enemies/Boss-SlugTank/Projectile_SlugTank.tscn")

export var projectile_speed = 1000

onready var player = null

func _ready():
	pass


func _process(delta):
	if player != null:
		
		pass

func shoot_projectile():
	# Untested!
	var new_pro = projectile.instance()
#	new_pro.velocity = Vector2(
#		cos($Sprite/Cannon_Anchor.rotation_degrees) * -projectile_speed,
#		sin($Sprite/Cannon_Anchor.rotation_degrees) * -projectile_speed
#		)
	new_pro.position = Vector2(
		$Sprite/Cannon_Anchor/Sprite_Cannon.global_position.x - 50,
		$Sprite/Cannon_Anchor/Sprite_Cannon.global_position.y
		)
	
	print(new_pro.position)
	print(cos($Sprite/Cannon_Anchor.rotation_degrees))
	print(sin($Sprite/Cannon_Anchor.rotation_degrees))
	
	get_tree().current_scene.add_child(new_pro)


func _input(event):
	if event.is_action_pressed("attack_b"):
		print("Check")
		shoot_projectile()

func _on_Detection_Player_body_entered(body):
	player = body
