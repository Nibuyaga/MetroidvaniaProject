extends Node2D


onready var playernode = Global.grab_current_level().get_node_or_null("Player")
var minion_preload = preload("Boss_minion.tscn")

export(int, "auto", "left", "right") var minion_behaviour


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func main_action():
	spawn_minion()

func spawn_minion():
	var minion = minion_preload.instance()
	minion.global_position = self.global_position
	if minion_behaviour == 0:	#auto
		minion.face_left = player_left_or_right()
	elif minion_behaviour == 1:	#left
		minion.face_left = true
	elif minion_behaviour == 2:	#right
		minion.face_left = false
	
	
	# !bandage fixing here
	#	,the variables like stats and health doesn't reset between nodes
	minion.stats["health"] = 1
	minion.stats["alive"] = true
	
	Global.grab_current_level().add_child(minion)

func player_left_or_right():
	# return true or false,
		# false, minion goes right (default)
		# true, minion goes left
	if playernode == null:
		return false
	
	if playernode.position.x < self.position.x:	#goes left
		return true
	else:
		return false


