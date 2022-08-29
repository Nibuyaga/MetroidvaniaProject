extends Control


var starting_area = "res://Rooms/HubLeft/HubLeft - 01.tscn"
var playerstartpos = Vector2(340, 140)


# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/NewGameButton.grab_focus()
	
	SaveNode.load_save()
	if SaveNode.save_dict["updated"] == true:
		$MainMenu/ContinueButton.visible = true



func _on_NewGameButton_pressed():
	Global.player_spawn_location = playerstartpos
	Global.goto_scene(starting_area)


func _on_ContinueButton_pressed():
	SaveNode.start_from_load()


func _on_QuitButton_pressed():
	get_tree().quit()

