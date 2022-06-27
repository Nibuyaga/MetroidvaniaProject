extends StaticBody2D


var destroyed_by = "dummy"


func destructableTile_created(input_change="dummy"):
	
	match input_change:
		"dummy":
			destroyed_by = "dummy"
			$Sprite.frame = 1
		"sword":
			destroyed_by = "sword"
			$Sprite.frame = 2
		"grenade":
			destroyed_by = "grenade"
			$Sprite.frame = 3

func destructableTile_destroyed(by_what = "no name"):
	
	if destroyed_by == by_what:
		queue_free()
