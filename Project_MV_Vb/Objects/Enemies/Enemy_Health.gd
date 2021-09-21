extends Node2D



func _ready():
	pass
	


func set_health(health):

	if health <= 0:
		$Health_Counter.text = "I'm dead!"
	else:
		$Health_Counter.text = String(health)
