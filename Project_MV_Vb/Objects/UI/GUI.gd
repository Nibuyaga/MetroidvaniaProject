extends MarginContainer





func update_bars(input):
	# current input is:
	# hp
	
	update_hp(input)


func update_hp(set_hp):
	$HBoxContainer/Bars/HPBar/Count/Background/Number.text = String(set_hp)
	$HBoxContainer/Bars/HPBar/Gauge.value = set_hp
