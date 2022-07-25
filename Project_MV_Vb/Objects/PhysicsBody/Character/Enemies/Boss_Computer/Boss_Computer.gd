extends "res://Objects/PhysicsBody/Character/Character.gd"


var timer = 0.0
export var reset_timer = 8.0

onready var timer_dict = {
	"spawn1": [2.0, true, $Minion_Spawner],
	"spawn2": [6.0, true, $Minion_Spawner2]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	timer += delta
	if timer >= reset_timer:
		timer = 0.0
		for entry0 in timer_dict:
			var entry = timer_dict[entry0]
			entry[1] = true
	
	for entry0 in timer_dict:
		var entry = timer_dict[entry0]
		if entry[0] <= timer and entry[1]:
			entry[1] = false
			entry[2].main_action()
	

func _on_Hurtbox_area_entered(area):
	if "damage" in area:	# This needs to be tested
		calc_health(area.damage)
	else:
		calc_health(1)
	print(stats["health"])

