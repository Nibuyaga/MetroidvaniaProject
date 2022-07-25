extends Area2D


onready var player_vars = get_node("/root/PlayerVariables")
onready var scene = self.owner.name

var effects = {
	'health_full' : ['health', 'increase', 999],
	'health_big' : ['health', 'increase', 16],
	'health_med' : ['health', 'increase', 4],
	'health_small' : ['health', 'increase', 1],
	'health_extend' : ['max_health', 'increase', 10],
	'sword' :  ['sword', 'set', true],
	'grenade' : ['guns', 'append', 1],
	'grapple' : ['guns', 'append', 2],
}
export(String, 
	"health_full", "health_big", "health_med", "health_small", 
	"health_extend", "sword", "grenade", "grapple") var pickup_name
# Because godot doesn't allow list unpacking I'm forced to repeat myself:
var pickup_names = [
	"health_full", "health_big", "health_med", "health_small", 
	"health_extend", "sword", "grenade", "grapple"
]

func _ready():
	#TODO: make the sprite in editor reflect this too
	$Sprite.set_frame(pickup_names.find(pickup_name,0))
	if scene in player_vars.pickups:
		if self.name in player_vars.pickups[scene]:
			queue_free()

func affect():
	if not pickup_name in effects:
		return
	var effect = effects[pickup_name]
	var name = effect[0]
	var function = effect[1]
	var value = effect[2]
	if function == 'increase':
		if not name in player_vars.stats:
			player_vars.stats[name] = 0
		player_vars.stats[name] += value
	if function == 'set':
		player_vars.stats[name] = value
	if function == 'append':
		if not name in player_vars.stats:
			player_vars.stats[name] = []
		player_vars.stats[name].append(value)

func _on_Pickup_body_entered(body):
	if not scene in player_vars.pickups:
		player_vars.pickups[scene] = []
	if not self.name in player_vars.pickups[scene]:
		player_vars.pickups[scene].append(self.name)
	affect()
	hide()
