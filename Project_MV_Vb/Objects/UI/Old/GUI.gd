extends MarginContainer

# var for the HP, delete when adding health etc. to player
var HPcurr = 10
var HPmax = 10
# var for the EP
var EPcurr = 10
var EPmax = 10

# BT, variables for the bullet textures
var bullet_texture = {
	0: preload("res://Objects/UI/Assets/normal_bullet.png"),
	1: preload("res://Objects/UI/Assets/grenade.png"),
	2: preload("res://Objects/UI/Assets/Grapp_icon.png")
	}
onready var bullet_node = get_node("VBox/HBox2/BulletBackground/BulletTexture")


# create reading health and health max on ready function
func _ready():
	update_hp(HPcurr)
	update_ep(EPcurr)


# for function testing purposes
func _input(_event):
#	if _event.is_action_pressed("attack_b"):
#		print("button check")
	
	pass


func update_bars(id, input):
	# current input is:
	# hp
	
	if id == "hp":
		update_hp(input)
	
	elif id == "ep":
		update_ep(input)
	
	elif id == "bullet":
		update_bullet(input)


func update_hp(set_hp):
	$VBox/HBox/Bars/HPBar/Count/Background/Number.text = String(set_hp) + "/" + String(HPmax)
	$VBox/HBox/Bars/HPBar/Gauge.value = set_hp

func update_ep(set_ep):
	$VBox/HBox/Bars/EPBar/Count/Background/Number.text = String(set_ep) + "/" + String(EPmax)
	$VBox/HBox/Bars/EPBar/Gauge.value = set_ep

func update_bullet(set_bullet):
	if typeof(set_bullet) == TYPE_INT:	# checks whether set_bullet is an integer
		if set_bullet in bullet_texture: 	# check if set_bullet is found in the dictionary
			bullet_node.texture = bullet_texture[set_bullet]
		else:
			print("bullet texture not found")
