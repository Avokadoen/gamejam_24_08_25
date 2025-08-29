extends Control

#Loads the main game scene
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn") #Update to actual final game scene

#Quits the game
func _on_quit_pressed() -> void:
	get_tree().quit()
