extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("pause"):
		# when paused
		if get_tree().paused == false:
			$pause_popup.show()
			get_tree().paused = true
			
		# when unpaused
		elif get_tree().paused == true:
			$pause_popup.hide()
			get_tree().paused = false

