extends StaticBody2D


export var damage = 2


# Detection state
func readydetect():
	$Detect.visible = true
	$Visual/Detect_Rectangle.visible = true
	$Detect/CollisionShape2D.set_deferred("disabled", false)

func enddetect():
	$Visual/Detect_Rectangle.visible = false
	$Detect/CollisionShape2D.set_deferred("disabled", true)
	$Detect.visible = false

# Shooting state
func readylaser():
	$AnimationPlayer.play("ReadyLaser")

func shootlaser():
	$AnimationPlayer.play("ShootLaser")
	$Laser/CollisionShape2D.set_deferred("disabled", false)

func stoplaser():
	$Laser/CollisionShape2D.set_deferred("disabled", true)

# If entered functions


func _on_Detect_body_entered(_body):
	enddetect()
	readylaser()
