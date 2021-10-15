extends Node


var player_spawn_location = null

# list of player variables

var velocity = null
var current_weapon = null
var health = null



func _ready():
	pass


func store_data(target):
	# current equips
	current_weapon = target.current_weapon
	
	# movement
	velocity = target.velocity
	
	# stats
	health = target.health


func get_data(target):
	target.velocity = velocity
	target.health = health
	# target.current_weapon = velocity
	# commented code crashes the game for unknown reasons
