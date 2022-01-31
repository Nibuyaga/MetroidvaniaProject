extends Node


var player_spawn_location = null

# list of player variables

var velocity = null
var gun = null
var stats = {}
var pickups = {}

func _ready():
	pass


func store_data(target):
	# movement
	velocity = target.velocity

func get_data(target):
	target.velocity = velocity
