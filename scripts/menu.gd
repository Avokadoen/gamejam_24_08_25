extends Control


@onready var button_hover_audio = $Button_Hover
@onready var play_audio_play = $MarginContainer/VBoxContainer/Play/Play_Click
@onready var quit_audio_play = $MarginContainer/VBoxContainer/Quit/Quit_Click

#Loads the main game scene
func _on_play_pressed() -> void:
	play_audio_play.play()

#Quits the game
func _on_quit_pressed() -> void:
	quit_audio_play.play()

func _on_play_click_finished() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn") #Update to actual final game scene

func _on_quit_click_finished() -> void:
	get_tree().quit()


func _on_play_mouse_entered() -> void:
	button_hover_audio.play()


func _on_quit_mouse_entered() -> void:
	button_hover_audio.play()
