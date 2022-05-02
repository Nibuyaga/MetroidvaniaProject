extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("pause"):
		# when paused
		if get_tree().paused == false:
			print("check1")
			$pause_popup.show()
			get_tree().paused = true
			
		# when unpaused
		elif get_tree().paused == true:
			print("check2")
			$pause_popup.hide()
			get_tree().paused = false

