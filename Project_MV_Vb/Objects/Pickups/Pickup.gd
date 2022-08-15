extends Area2D


onready var player_vars = get_node("/root/PlayerVariables")
onready var scene = self.owner.name
var taken = false

var effects = {
	'health_full' : ['health', 'increase', 999],
	'health_big' : ['health', 'increase', 16],
	'health_med' : ['health', 'increase', 4],
	'health_small' : ['health', 'increase', 1],
	'health_extend' : ['max_health', 'increase', 10],
	'sword' :  ['has_sword', 'set', true],
	'walljump' :  ['can_wall_jump', 'set', true],	
	'doublejump' :  ['can_double_jump', 'set', true],
	'grenade' : ['gun_max_cycle', 'set', 2],
	'grapple' : ['gun_max_cycle', 'set', 3],
}

export(String, 
	"health_full", "health_big", "health_med", "health_small", 
	"health_extend", "sword", "walljump", "doublejump", "grenade", "grapple") var pickup_name
# Because godot doesn't allow list unpacking I'm forced to repeat myself:
var pickup_names = [
	"health_full", "health_big", "health_med", "health_small", 
	"health_extend", "sword", "walljump", "doublejump", "grenade", "grapple"
]

func _ready():	
	#TODO: make the sprite in editor reflect this too
	$Sprite.set_frame(pickup_names.find(pickup_name,0))
	if scene in player_vars.pickups:
		if self.name in player_vars.pickups[scene]:
			queue_free()

func affect():
	if taken:
		return
	taken = true
	$taken.play()
	var stats = Global.grab_current_level().get_node("Player").stats
	if not pickup_name in effects:
		return
	var effect = effects[pickup_name]
	var name = effect[0]
	var function = effect[1]
	var value = effect[2]
	if function == 'increase':
		if not name in stats:
			stats[name] = 0
		stats[name] += value
	if function == 'set':
		stats[name] = value
	if function == 'append':
		if not name in stats:
			stats[name] = []
		stats[name].append(value)

func _on_Pickup_body_entered(body):
	if not scene in player_vars.pickups:
		player_vars.pickups[scene] = []
	if not self.name in player_vars.pickups[scene]:
		player_vars.pickups[scene].append(self.name)
	affect()
	hide()
	queue_free()
