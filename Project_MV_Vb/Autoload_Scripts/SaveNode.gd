extends Node

# game saves are saved in 
# "user"/Appdata/Roaming/Godot/app_userdata/"nameOfProject"



var save_dict = {
	"position_x" : 0,
	"position_y" : 0,
	"room": "",
	"player_pickups": {},
	"updated": false
}


var save_file_location = "user://mv_checkpoint.save"



# checkpoint system
var checkpoint = {
	"room": "",
	"position": Vector2(0,0)
}
var update_playervar = true

func _ready():
	# updates playerstats, mainly used for respawn purposes
	if Global.grab_current_level().get_node_or_null("Player") != null:
		PlayerVariables.store_data(Global.grab_current_level().get_node_or_null("Player"))



func something2():
	# stores the current stats of player
	# used for?
	# is unused, don't remember where it was used for
	var player_node = Global.grab_current_level().get_node_or_null("Player")
	if player_node != null and update_playervar:
		PlayerVariables.store_data(player_node)
	else:
		update_playervar = true

# function for checkpoint
func update_checkpoint(room_path = Global.grab_current_level().filename, player_position = Global.grab_current_level().get_node_or_null("Player").position):
	if checkpoint["room"] != room_path:
		# updates the checkpoint
		checkpoint["room"] = room_path
		checkpoint["position"] = player_position
		
		# start storing the checkpoint in a local file
		complete_save()

func restart_from_checkpoint():
	Global.player_spawn_location = checkpoint["position"]
	Global.goto_scene(checkpoint["room"])
	update_playervar = false	# a bit of messy code
	PlayerVariables.stats["health"] = PlayerVariables.stats["max_health"]
	PlayerVariables.stats["alive"] = true

func _physics_process(delta):
	# checkpoint restart on a button
	if Input.is_action_just_released("SHORTCUT_restart_to_checkpoint"):
		restart_from_checkpoint()
	


# handles creating a save on the pc
# use complete_save()
func update_save_dict():
	# happens at every screen transition
	# saves the room coördinates
	save_dict["room"] = checkpoint["room"]
	save_dict["position_x"] = checkpoint["position"].x
	save_dict["position_y"] = checkpoint["position"].y
	
	# saves the stats and pickups
	for x in PlayerVariables.stats:
		save_dict[x] = PlayerVariables.stats[x]
	save_dict["player_pickups"] = PlayerVariables.pickups
	
	if save_dict["updated"] != true:
		save_dict["updated"] = true

func save_game():
	# happens at every screen transition, consider changing
	var save_gamev = File.new()
	save_gamev.open(save_file_location, File.WRITE)
	
	save_gamev.store_line(to_json(save_dict))
	
	save_gamev.close()

func complete_save():
	# combines the 2 functions for convenience
	update_save_dict()
	save_game()


# handles loading save from the pc
func load_save():
	# happens at the start of the game
	var save_gamev = File.new()
	if not save_gamev.file_exists(save_file_location):
		print("save file not found")
	else:
		save_gamev.open(save_file_location, File.READ)
		save_dict = parse_json(save_gamev.get_line())
		save_gamev.close()
		


func start_from_load():
	# for the start screen mainly
	
	for x in PlayerVariables.stats:
		if x in save_dict:
			PlayerVariables.stats[x] = save_dict[x]
		else:
			print("odd key found")
			print(x)
	
	PlayerVariables.pickups = save_dict["player_pickups"]
	
	Global.player_spawn_location = Vector2(0,0)
	Global.player_spawn_location.x = save_dict["position_x"]
	Global.player_spawn_location.y = save_dict["position_y"]
	Global.goto_scene(save_dict["room"])

# random unused files
func test_save():
	if false:	# for testing file saving
		var file_test = File.new()
		file_test.open(save_file_location, File.WRITE)
		
		var test_content = {"hello": 5, "World": "Iam"}
		file_test.store_line(to_json(test_content))
		file_test.close()
		print("file saved")
	
	if false:
		var file_test = File.new()
		if not file_test.file_exists(save_file_location):
			print("save file not found")
		else:
			file_test.open(save_file_location, File.READ)
			var file_data = parse_json(file_test.get_line())
			print(file_data)
			file_test.close()
			print("file opened")
