extends Node


var player_spawn_location = null

# list of player variables

var velocity = Vector2(0,0)
var gun = null
var stats = {	# these are the starting stats of the player
	'gun':0,
	'gun_max_cycle': 1,
	'max_health':10,
	'health':10,
	'alive': true,
	'has_sword': false,
	'can_wall_jump': false,
	'can_double_jump': false,
	'double_jump': 0,
	'double_jumps': 1,
}
var pickups = {}

# a (temporary) solution to prevent that stats turn to null
var gameplay_is_running = false

func _ready():
	pass


func store_data(target):
	# movement
	velocity = target.velocity
	stats = target.stats

func get_data(target):
	target.velocity = velocity
	target.stats = stats
