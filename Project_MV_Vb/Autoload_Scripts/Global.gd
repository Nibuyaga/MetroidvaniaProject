extends Node


var current_scene = null	# creates a variable for the "current level"
var player_spawn_location = null	# variable for player location in the scene
var player_node = null
onready var root = get_tree().get_root()	# shortcut var for getting the root

var checkpoint = {
	"room": "",
	"position": Vector2(0,0)
}
var update_playervar = true

var spn_on_in_goto_scene = true	# variable which determines whether a new player node will spawn or not
var stored_path = ""

# for tilemap borders
var tilemap_border_low = []
var tilemap_border_high = []

# !Consider changing this when dealing introducing menus
func _ready():
	
	# gets the last child of the root, which generally is the loaded scene, the current level
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# A convenience check whether or not the player will spawn
	if false:
		# checks and if confirmed copies the player_spawn_location of level
		#	if not changes the spawn location to the bottom middle of the level
		if "player_spawn_location" in current_scene:
			if current_scene.player_spawn_location.x == 0 or current_scene.player_spawn_location.y == 0:
				print("player spawn location contain 0")
			else:
				player_spawn_location = current_scene.player_spawn_location
				player_spawn_location.y += -18	# a correction
		else:
			print("player spawn location not found in starting scene")
		# Changes the starting spawn location to the bottommiddle of the level
		#	If the player_spawn_location == null
			var roomsize_ready = current_scene.get_node_or_null("RoomSizeReference")
			if roomsize_ready != null:
				player_spawn_location = Vector2(
					roomsize_ready.position.x / 2,
					roomsize_ready.position.y - 38
				)
		
		# adds player node if player node is lacking
		player_node = _spawn_player_node()
		
		if player_spawn_location != null:
			player_node.position = player_spawn_location
		else:
			player_node.position = Vector2(150,100)
			player_spawn_location = Vector2(150,100)
	
	# changes camera to fit current room, at the start of the game
		_change_camera_limit()
	
	# updates checkpoint
		update_checkpoint()
	
	# updates playerstats, mainly used for respawn purposes
	if grab_current_level().get_node_or_null("Player") != null:
		PlayerVariables.store_data(grab_current_level().get_node_or_null("Player"))


func _physics_process(delta):
	# checkpoint restart
	if Input.is_action_just_released("SHORTCUT_restart_to_checkpoint"):
		restart_from_checkpoint()
	


# a somewhat easier way of getting the current level
#  , if there is no additional nodes of course
func grab_current_level():
	return get_tree().get_root().get_child(
		get_tree().get_root().get_child_count()-1
	)

func goto_scene(path):
	
	# stores path in var after animation
	stored_path = path
	
	# a check to make sure the playervariable storing is done proper
	PlayerVariables.gameplay_is_running = true
	
	#! Add a freeze playing node function here!
	#	The game still plays during the fade animation
	
	# plays animation
	$AnimationPlayer.play("FadeToBlackScreen")


func goto_scene2():
	
	# stores the current stats of player
	player_node = grab_current_level().get_node_or_null("Player")
	if player_node != null and update_playervar:
		PlayerVariables.store_data(player_node)
	else:
		update_playervar = true
	
	if stored_path != "":
		call_deferred("_deferred_goto_scene", stored_path)
		# call_deferred starts the function after all the code from the current scene has been completed
		stored_path = ""
		# reset stored_path
		$AnimationPlayer.play("FadeToTransparent")
		
	else:
		print("!Trying to start goto_scene2 without stored_path")



func _deferred_goto_scene(path):
	
	current_scene.free()
	
	var sceneLoad = ResourceLoader.load(path)
	
	current_scene = sceneLoad.instance()
	
	get_tree().get_root().add_child(current_scene)
	
	# adds the player node if the scene lacks a player node
	# doesn't (seem) to actually check if there is 
	if spn_on_in_goto_scene == true:
		_spawn_player_node()
	
	if player_spawn_location != null:
		player_node = grab_current_level().get_node_or_null("Player")
		if player_node != null:
			player_node.set_position(player_spawn_location)
		else:
			print("player_node == null, player_node not found, written by Global/_deferred_goto_scene")
		
	else:
		print("player_spawn_location is missing, written by Global/_deferred_goto_scene")
	
	# updates checkpoint
	update_checkpoint(path, player_node.position)
	
	_change_camera_limit()
	

# function which spawns the player, when missing
func _spawn_player_node():
	var player_node_spn = grab_current_level().get_node_or_null("Player")
	var spn_player_load = load("res://Objects/PhysicsBody/Character/Player/Player.tscn").instance()
	
	if player_node_spn == null:
		grab_current_level().add_child(spn_player_load)
		return spn_player_load
	else:
		print("Player node already in level")
		return player_node_spn


# function for updating checkpoint
func update_checkpoint(room_path = grab_current_level().filename, player_position = grab_current_level().get_node_or_null("Player").position):
	checkpoint["room"] = room_path
	checkpoint["position"] = player_position


func restart_from_checkpoint():
	player_spawn_location = checkpoint["position"]
	goto_scene(checkpoint["room"])
	update_playervar = false	# a bit of messy code
	PlayerVariables.stats["health"] = PlayerVariables.stats["max_health"]


# variable and function for changing camera_limit
# !consider moving this code to the player or player_global script
var player_ccl = null
var camera_ccl = null
var current_scene_ccl = null
var roomsize_ccl = null

func _change_camera_limit():
	camera_ccl = grab_current_level().get_node_or_null("Player/CameraDirection/Camera2D")
	player_ccl = grab_current_level().get_node_or_null("Player")
	current_scene_ccl = root.get_child(root.get_child_count()-1)
	roomsize_ccl = current_scene_ccl.get_node_or_null("RoomSizeReference")
	
	
	if camera_ccl != null and current_scene_ccl != null:
		# starting roomsize check
		
		# for when camera ranges are based on "Roomsizereference"
		if roomsize_ccl != null:
			camera_ccl.limit_right = roomsize_ccl.position.x
			camera_ccl.limit_bottom = roomsize_ccl.position.y
		
		# for when camera ranges are based on tilemap size
		elif tilemap_border_low.size() != 0 or tilemap_border_high.size() != 0:
			if tilemap_border_low.size() != 0:
				pass
			else:
				print("tilemap_border_low is empty, used for camera, written by Global")
				camera_ccl.limit_left = -100000
				camera_ccl.limit_top = -100000
			
			if tilemap_border_high.size() != 0:
				pass
			else:
				print("tilemap_border_high is empty, used for camera, written by Global")
				camera_ccl.limit_right = 100000
				camera_ccl.limit_bottom = 100000
			
			tilemap_border_high.clear()
			tilemap_border_low.clear()
		
		# When any of the camera ranges fails to work completely
		else:
			print("unable to find information for camera, written by GlobalScript/_change_camera_limit")
			# lower limits, point is left under
			camera_ccl.limit_left = -100000
			camera_ccl.limit_top = -100000
			
			# Upper limits, point is right under
			camera_ccl.limit_right = 100000
			camera_ccl.limit_bottom = 100000
			
	else:
		print("unable to find camera or current_scene node, written by GlobalScript/_change_camera_limit")
	

func checkon_tilemap_size():
	var level_nodes = grab_current_level().get_children()
	
	for currentNode in level_nodes:
		if currentNode.is_class("TileMap"):
			print("notice TileMap")

