extends "res://Objects/PhysicsBody/PhysicsBody.gd"








func _on_Collision_detector_body_entered(_body):
	queue_free()
