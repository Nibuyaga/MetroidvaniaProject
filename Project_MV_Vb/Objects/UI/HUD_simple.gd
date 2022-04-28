extends MarginContainer

# variables for bullet icons
# consider changing the "bulletIcon" numbers into actual titles
var bulletIcon = {
	0: preload("res://Objects/UI/GUI_Assets/Weapon Icon/Icon_Bullet.png"),
	1: preload("res://Objects/UI/GUI_Assets/Weapon Icon/Icon_Grenade.png"),
	2: preload("res://Objects/UI/GUI_Assets/Weapon Icon/Icon_GrappHook.png")
}

# variables for the bar/gauges
var pixelPerValue = 3


# bullet icon switching
func updateBulletIcon(targetIcon):
		$HBox/Icon_BulletBackground/Icon_Bullet.texture = bulletIcon[targetIcon]


#
func update_hud(target_var, related_stat):
	match target_var:
		"hp":
			updateCurrentHP(related_stat)
		"max_hp":
			updateMaxHP(related_stat)
		"ep":
			updateCurrentEP(related_stat)
		"max_ep":
			updateMaxEP(related_stat)


# updating HP
func updateCurrentHP(currentHP):
	$HBox/VBox_Gauge/HP_Bar/Bar.value = currentHP

func updateMaxHP(maxHP):
	$HBox/VBox_Gauge/HP_Bar/Bar.max_value = maxHP
	$HBox/VBox_Gauge/HP_Bar/Bar.rect_size.x = maxHP * pixelPerValue

# updating EP
func updateCurrentEP(currentEP):
	$HBox/VBox_Gauge/HP_Bar/Bar.value = currentEP

func updateMaxEP(maxEP):
	$HBox/VBox_Gauge/HP_Bar/Bar.max_value = maxEP
	$HBox/VBox_Gauge/HP_Bar/Bar.rect_size.x = maxEP * pixelPerValue


# handy dandy functions
func update_multiple_at_ready(input_dictionary):
	if typeof(input_dictionary) == TYPE_DICTIONARY:
		for currentItem in input_dictionary:
			match currentItem:
				"health":
					updateCurrentHP(input_dictionary[currentItem])
				"max_health":
					updateMaxHP(input_dictionary[currentItem])
				"gun":
					updateBulletIcon(input_dictionary[currentItem])
				
	else:
		print("input @updateABunchAtReady is not a dictionary")
		print(typeof(input_dictionary))

