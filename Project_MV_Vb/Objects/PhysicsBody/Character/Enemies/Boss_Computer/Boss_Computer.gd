extends "res://Objects/PhysicsBody/Character/Character.gd"

var hpcheck = {
	1: true,
	2: true,
	3: true
}

enum STATE {
	normal,
	large_cannon
}
var state = STATE.normal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match state:
		STATE.normal:
			timed_events(delta)
	
	


func _on_Hurtbox_area_entered(area):
	if "damage" in area:	# This needs to be tested
		calc_health(area.damage, false)
	else:
		calc_health(1, false)
	print("boss health: " + str(stats["health"]) )
	
	if hpcheck[1] and stats["health"] <= 70:
		start_large_cannon()
		hpcheck[1] = false
	elif hpcheck[2] and stats["health"] <= 40:
		start_large_cannon()
		hpcheck[2] = false
	elif hpcheck[3] and stats["health"] <= 10:
		start_large_cannon()
		hpcheck[3] = false
	
	if stats["health"] <= 0:
		end_self()	# !at the moment it just queu free itself!


# variables for timer
var timer = 0.0
export var reset_timer = 8.0
onready var timer_dict = {
	"spawn1": [2.0, true, $Minion_Spawner],
	"spawn2": [6.0, true, $Minion_Spawner2],
	"test": [3.0, true, self]
}

func timed_events(delta):
	timer += delta
	if timer >= reset_timer:
		timer = 0.0
		for entry0 in timer_dict:
			var entry = timer_dict[entry0]
			entry[1] = true
	
	for entry0 in timer_dict:
		var entry = timer_dict[entry0]
		if entry[1] and entry[0] <= timer:
			entry[1] = false
			entry[2].main_action()

func main_action():	#mainly used for test purposes
	if false:
		start_large_cannon()


func start_large_cannon():
	$AnimationPlayer.play("Large_Cannon")
	$Barrier.shield_hard_down()
	$Large_cannon.activate_cannon()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _on_Large_cannon_shotfired():
	$AnimationPlayer.play("Large_Cannon_End")

func end_large_cannon():
	$Barrier.shield_up()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)

func end_self():	# ! at the moment rushed
	queue_free()	
