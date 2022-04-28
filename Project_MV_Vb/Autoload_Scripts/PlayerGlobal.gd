extends Node


var player_spawn_location = null

# list of player variables

var velocity = null
var gun = null
var stats = {}
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
