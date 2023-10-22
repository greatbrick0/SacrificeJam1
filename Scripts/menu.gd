extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_level.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func _process(delta):
	if(Input.is_action_just_released("Jump")):
		_on_start_button_pressed()
	if(Input.is_action_just_released("Exit")):
		_on_quit_button_pressed()
