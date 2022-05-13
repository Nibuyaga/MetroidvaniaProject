extends StaticBody2D

# listKeys, basically all the nodes it can interact to open
var listKeys = [
	"NormalBullet"
]
export var closeDirectly = true

export var flip_h = false



func _ready():
	if flip_h:
		$Sprite.set("flip_h", true)
	



func open_coll():
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)

func close_coll():
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D.set_deferred("monitoring", true)


func _on_Area2D_area_entered(area):
	
	# Does something when Node name is in listKeys
	if area.get_name() in listKeys:
		open_coll()
		$AnimationPlayer.play("Open")


func _on_Player_Detect_body_entered(body):
	closeDirectly = false


func _on_Player_Detect_body_exited(body):
	# Start a closing Timer
	pass


func _on_Timer_InstantClose_timeout():
	if closeDirectly == true:
		close_coll()
		$AnimationPlayer.play("Instant Close")
