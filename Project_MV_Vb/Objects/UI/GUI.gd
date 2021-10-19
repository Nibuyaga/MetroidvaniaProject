extends MarginContainer

# delete when adding health etc. to player
var HPcurr = 10
var HPmax = 10


# create reading health and health max on ready function
func _ready():
	update_hp(HPcurr)
	


func update_bars(input):
	# current input is:
	# hp
	
	update_hp(input)


func update_hp(set_hp):
	$HBoxContainer/Bars/HPBar/Count/Background/Number.text = String(set_hp) + "/" + String(HPmax)
	$HBoxContainer/Bars/HPBar/Gauge.value = set_hp
